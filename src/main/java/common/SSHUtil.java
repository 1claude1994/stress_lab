package common;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.nio.charset.StandardCharsets;
import java.util.Properties;
import java.util.function.Consumer;

import com.jcraft.jsch.ChannelShell;
import com.jcraft.jsch.JSch;
import com.jcraft.jsch.Session;

/**
 * SSH 연결 및 명령어 실행을 위한 유틸리티 클래스
 */
public class SSHUtil {

    private final String host;
    private final int port;
    private final String user;
    private final String password;

    private Session session;
    private ChannelShell shell;
    private InputStream input;
    private OutputStream output;

    public SSHUtil(String host, int port, String user, String password) {
        this.host = host;
        this.port = port;
        this.user = user;
        this.password = password;
    }

    /**
     * SSH 서버 연결
     */
    public void connect() throws Exception {

        // 이미 연결되어 있으면 다시 연결하지 않음
        if (session != null && session.isConnected()
                && shell != null && shell.isConnected()) {
            return;
        }

        JSch jsch = new JSch();

        session = jsch.getSession(user, host, port);
        session.setPassword(password);

        Properties config = new Properties();
        config.put("StrictHostKeyChecking", "no");
        session.setConfig(config);

        session.connect(30000);

        shell = (ChannelShell) session.openChannel("shell");

        shell.setPty(true);

        shell.connect(30000);

        // 채널 연결 후 스트림 획득
        input = shell.getInputStream();
        output = shell.getOutputStream();

        System.out.println("SSH CONNECTED : " + host + ":" + port);
    }

    /**
     * 명령어 전송
     */
    public void send(String command) throws Exception {

        if (output == null) {
            throw new IllegalStateException(
                "SSH output stream이 초기화되지 않았습니다. connect()를 먼저 호출하세요."
            );
        }

        System.out.println("SEND : " + command);

        output.write(
            (command + "\n").getBytes(StandardCharsets.UTF_8)
        );

        output.flush();
    }

    /**
     * 서버 출력 텍스트 정리
     */
    private String cleanOutput(String text) {
        return text.replaceAll(
            "\u001B\\[[;\\d?]*[ -/]*[@-~]",
            ""
        );
    }

    /**
     * 서버 출력 읽기 시작
     */
    public void startReading(Consumer<String> consumer) {

        new Thread(() -> {

            byte[] buffer = new byte[4096];

            try {

                while (true) {

                    int len = input.read(buffer);

                    if (len == -1) {
                        break;
                    }

                    if (len > 0) {

                        String text = new String(
                            buffer,
                            0,
                            len,
                            StandardCharsets.UTF_8
                        );

                        consumer.accept(cleanOutput(text));
                    }
                }

            } catch (Exception e) {

                consumer.accept(
                    "[ERROR] " + e.getMessage()
                );
            }

        }).start();
    }

    /**
     * SSH 명령 실행
     */
    public String execute(String command) throws Exception {

        // 연결되지 않았다면 자동 연결
        connect();

        send(command);

        StringBuilder sb = new StringBuilder();

        byte[] buffer = new byte[4096];

        long startTime = System.currentTimeMillis();

        // 최대 30초 동안 결과 수집
        while (System.currentTimeMillis() - startTime < 30000) {

            if (input.available() > 0) {

                int len = input.read(buffer);

                if (len == -1) {
                    break;
                }

                if (len > 0) {

                    String text = new String(
                        buffer,
                        0,
                        len,
                        StandardCharsets.UTF_8
                    );

                    sb.append(cleanOutput(text));
                }

            } else {

                Thread.sleep(100);
            }
        }

        return sb.toString();
    }

    /**
     * SSH 연결 종료
     */
    public void disconnect() {

        try {

            if (shell != null) {
                shell.disconnect();
            }

            if (session != null) {
                session.disconnect();
            }

        } catch (Exception ignored) {
        }
    }
}