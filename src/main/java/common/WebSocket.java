package common;

import java.io.IOException;
import javax.websocket.*;
import javax.websocket.server.ServerEndpoint;

/**
 * WebSocket 서버 엔드포인트 클래스
 * - 클라이언트와 WebSocket 연결을 맺고 SSHUtil을 통해 원격 서버와 통신
 * - 클라이언트가 보낸 메시지를 SSH 서버에 전달하고,
 *   SSH 서버의 응답을 다시 클라이언트로 전송한다.
 */
@ServerEndpoint("/terminal")
public class WebSocket {

    private SSHUtil ssh; // SSH 연결 유틸리티 객체

    /**
     * WebSocket 연결이 열렸을 때 호출
     * - SSH 서버에 연결
     * - 연결 성공 메시지를 클라이언트에 전송
     * - SSH 서버 출력 데이터를 클라이언트로 전달하는 스레드 시작
     */
    @OnOpen
    public void onOpen(Session ws) {
        try {
            // SSH 연결 생성
            ssh = new SSHUtil("192.168.0.25", 22, "claude", "1234");
            ssh.connect();

            // 클라이언트에 연결 성공 메시지 전송
            ws.getBasicRemote().sendText("SSH Connected.\n");

            // SSH 서버 출력 읽기 시작 → 클라이언트로 전달
            ssh.startReading(data -> {
                synchronized (ws) {
                    try {
                        if (ws.isOpen()) {
                            ws.getBasicRemote().sendText(data);
                        }
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
            });

        } catch (Exception e) {
            try {
                ws.getBasicRemote().sendText("[ERROR] " + e.getMessage());
            } catch (IOException ignored) {}
        }
    }

    /**
     * 클라이언트가 메시지를 보냈을 때 호출
     * - "exit" 명령어가 오면 WebSocket 연결 종료
     * - 그 외에는 SSH 서버로 명령어 전달
     */
    @OnMessage
    public void onMessage(String command, Session ws) {
        try {
            if ("exit".equalsIgnoreCase(command.trim())) {
                ws.close(); // 연결 종료
                return;
            }
            ssh.send(command); // SSH 서버로 명령어 전달
        } catch (Exception e) {
            try {
                ws.getBasicRemote().sendText("[ERROR] " + e.getMessage());
            } catch (IOException ignored) {}
        }
    }

    /**
     * WebSocket 연결이 닫혔을 때 호출
     * - SSH 연결 종료
     */
    @OnClose
    public void onClose(Session ws) {
        if (ssh != null) {
            ssh.disconnect();
        }
    }

    /**
     * WebSocket 에러 발생 시 호출
     * - SSH 연결 종료
     */
    @OnError
    public void onError(Session ws, Throwable t) {
        if (ssh != null) {
            ssh.disconnect();
        }
    }
}