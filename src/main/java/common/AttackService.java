package common;

/**
 * 공격/스캔 서비스 공통 인터페이스
 */
public interface AttackService {
    AttackResult execute(String target, String options);
}
