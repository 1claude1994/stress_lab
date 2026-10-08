package service;

import common.AttackResult;
import common.AttackService;
import common.SSHUtil;

/**
 * =====================================================
 * Nmap Port Scan Service
 * =====================================================
 *
 * 역할
 *  - Nmap 명령 생성
 *  - SSH를 통해 Kali 서버에서 실행
 *  - 실행 결과를 AttackResult로 반환
 */
public class PortScanService implements AttackService {

    /** SSH 연결 객체 */
    private final SSHUtil ssh;

    public PortScanService(SSHUtil ssh) {
        this.ssh = ssh;
    }

    @Override
    public AttackResult execute(String target, String options) {

        // 대상 IP 검증
        if (target == null || target.trim().isEmpty()) {
            return new AttackResult(false, "ERROR : Target IP를 입력하세요.");
        }

        // Nmap 명령 생성
        StringBuilder command = new StringBuilder("nmap ");

        if (options != null && !options.trim().isEmpty()) {
            command.append(options).append(" ");
        }

        command.append(target);

        try {

            // 원격 Kali에서 실행
            String result = ssh.execute(command.toString());

            if (result == null || result.trim().isEmpty()) {
                result = "nmap은 실행되었지만 출력 결과가 없습니다.";
            }

            return new AttackResult(true, result);

        } catch (Exception e) {

            return new AttackResult(false, "ERROR : " + e.getMessage());
        }
    }
}