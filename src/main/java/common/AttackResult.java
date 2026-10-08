package common;

/**
 * 공격/스캔 결과를 담는 공통 DTO
 */
public class AttackResult {
    private boolean success;
    private String message;

    public AttackResult(boolean success, String message) {
        this.success = success;
        this.message = message;
    }

    public boolean isSuccess() { return success; }
    public String getMessage() { return message; }
}
