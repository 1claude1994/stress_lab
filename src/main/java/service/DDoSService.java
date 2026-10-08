package service;

import common.AttackResult;
import common.SSHUtil;

/**
 * =====================================================
 * DDoS Service
 * =====================================================
 *
 * 역할
 * -----------------------------------------------------
 * - DDoS 테스트 명령 생성
 * - SSH를 통해 Kali 서버 실행
 * - 결과 반환
 */
public class DDoSService {

    private final SSHUtil ssh;

    public DDoSService(SSHUtil ssh) {
        this.ssh = ssh;
    }

    /** DDoS 실행 */
    public AttackResult execute(String attackType,
                                String target,
                                String port,
                                String intensity,
                                String delay,
                                String randSource) {

        if (attackType == null || attackType.trim().isEmpty()) {
            return new AttackResult(false, "공격 방식을 선택하세요.");
        }
        if (target == null || target.trim().isEmpty()) {
            return new AttackResult(false, "Target 입력 필요");
        }

        String command = buildCommand(attackType, target, port, intensity, delay, randSource);

        try {
            String result = ssh.execute(command);
            if (result == null || result.trim().isEmpty()) {
                result = "실행 결과가 없습니다.";
            }
            return new AttackResult(true, result);
        } catch (Exception e) {
            return new AttackResult(false, "ERROR : " + e.getMessage());
        }
    }

    /** 명령어 생성 */
    private String buildCommand(String attackType,
                                String target,
                                String port,
                                String intensity,
                                String delay,
                                String randSource) {

        StringBuilder cmd = new StringBuilder();
        cmd.append(attackType);

        if (port != null && !port.trim().isEmpty()) cmd.append(" -p ").append(port);
        if (intensity != null && !intensity.trim().isEmpty()) cmd.append(" -c ").append(intensity);
        if (delay != null && !delay.trim().isEmpty()) cmd.append(" -i u").append(delay);
        if (randSource != null && !randSource.trim().isEmpty()) cmd.append(" ").append(randSource);

        cmd.append(" ").append(target);
        return cmd.toString();
    }
}