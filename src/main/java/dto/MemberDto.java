package dto;

import java.sql.Timestamp;

/**
 * ==========================================================
 * MemberDto
 * ==========================================================
 *
 * 데이터 전송 객체(Data Transfer Object, DTO)
 * ----------------------------------------------------------
 * - 사용자 정보(회원 정보)를 담는 객체
 * - Controller ↔ Service ↔ DAO 간 데이터 전달에 사용
 */
public class MemberDto {

    /** 사용자 계정 아이디 (Primary Key) */
    private String id;

    /** 사용자 이름 */
    private String name;

    /** 사용자 계정 비밀번호 */
    private String password;

    /** 사용자 이메일 주소 */
    private String email;

    /** 계정 생성일시 */
    private Timestamp createdAt;

    // 기본 생성자
    public MemberDto() {}
    
    // 모든 필드를 초기화하는 생성자
    public MemberDto(String id, String name, String password, String email, Timestamp createdAt) {
        this.id = id;
        this.name = name;
        this.password = password;
        this.email = email;
        this.createdAt = createdAt;
    }

    // Getter & Setter 메서드
    public String getId() {
        return id;
    }
    public void setId(String id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }

    public String getPassword() {
        return password;
    }
    public void setPassword(String password) {
        this.password = password;
    }

    public String getEmail() {
        return email;
    }
    public void setEmail(String email) {
        this.email = email;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    // 객체 정보를 문자열로 반환 (디버깅용)
    @Override
    public String toString() {
        return "MemberDto{" +
                "id='" + id + '\'' +
                ", name='" + name + '\'' +
                ", password='" + password + '\'' +
                ", email='" + email + '\'' +
                ", createdAt=" + createdAt +
                '}';
    }
}