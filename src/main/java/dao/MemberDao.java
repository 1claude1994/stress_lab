package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import common.MariaDBConnection;
import dto.MemberDto;

/**
 * 회원(Member) 데이터베이스 연동을 담당하는 DAO 클래스입니다.
 */
public class MemberDao {

    /**
     * 사용자의 아이디와 비밀번호를 검증하고 회원 정보를 조회합니다.
     *
     * @param id       조회할 회원 아이디
     * @param password 조회할 회원 비밀번호
     * @return 일치하는 회원이 존재할 경우 MemberDto 객체, 없거나 오류 발생 시 null 반환
     */
    public MemberDto login(String id, String password) {
        MemberDto user = null;

        String sql = "SELECT id, name, password, email, created_at " +
                     "FROM member " +
                     "WHERE id = ? AND password = ?";

        try (Connection conn = MariaDBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, id);
            pstmt.setString(2, password);

            try (ResultSet rs = pstmt.executeQuery()) {

                if (rs.next()) {
                    user = new MemberDto();

                    user.setId(rs.getString("id"));
                    user.setName(rs.getString("name"));
                    user.setPassword(rs.getString("password"));
                    user.setEmail(rs.getString("email"));
                    user.setCreatedAt(rs.getTimestamp("created_at"));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return user;
    }


    /**
     * 새로운 회원을 데이터베이스에 등록(회원가입)합니다.
     *
     * @param user 가입할 회원 정보가 담긴 MemberDto 객체
     * @return 회원가입 성공 시 true, 실패 시 false 반환
     */
    public boolean insert(MemberDto user) {

        String sql = "INSERT INTO member(id, name, password, email) " +
                     "VALUES(?, ?, ?, ?)";

        try (Connection conn = MariaDBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, user.getId());
            pstmt.setString(2, user.getName());
            pstmt.setString(3, user.getPassword());
            pstmt.setString(4, user.getEmail());

            return pstmt.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }


    /**
     * 입력받은 아이디가 이미 데이터베이스에 존재하는지 중복 여부를 확인합니다.
     *
     * @param id 확인할 회원 아이디
     * @return 중복된 아이디가 존재하면 true, 사용 가능하면 false 반환
     */
    public boolean isIdDuplicate(String id) {

        String sql = "SELECT COUNT(*) " +
                     "FROM member " +
                     "WHERE id = ?";

        try (Connection conn = MariaDBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, id);

            try (ResultSet rs = pstmt.executeQuery()) {

                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }


    /**
     * 회원의 이름과 이메일 주소 등 개인정보를 수정합니다.
     *
     * @param id    수정할 대상 회원 아이디
     * @param name  변경할 이름
     * @param email 변경할 이메일 주소
     * @return 수정 성공 시 true, 실패 시 false 반환
     */
    public boolean updateMember(String id, String name, String email) {

        String sql = "UPDATE member " +
                     "SET name = ?, email = ? " +
                     "WHERE id = ?";

        try (Connection conn = MariaDBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, name);
            pstmt.setString(2, email);
            pstmt.setString(3, id);

            return pstmt.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }


    /**
     * 회원의 아이디와 비밀번호가 올바르게 매칭되는지 확인합니다.
     *
     * @param id       확인할 회원 아이디
     * @param password 확인할 비밀번호
     * @return 정보가 일치하면 true, 일치하지 않거나 오류 시 false 반환
     */
    public boolean checkPassword(String id, String password) {

        String sql = "SELECT COUNT(*) " +
                     "FROM member " +
                     "WHERE id = ? AND password = ?";

        try (Connection conn = MariaDBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, id);
            pstmt.setString(2, password);

            try (ResultSet rs = pstmt.executeQuery()) {

                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }


    /**
     * 회원의 비밀번호를 새로운 비밀번호로 변경합니다.
     *
     * @param id          비밀번호를 변경할 회원 아이디
     * @param newPassword 새로 설정할 비밀번호
     * @return 변경 성공 시 true, 실패 시 false 반환
     */
    public boolean updatePassword(String id, String newPassword) {

        String sql = "UPDATE member " +
                     "SET password = ? " +
                     "WHERE id = ?";

        try (Connection conn = MariaDBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, newPassword);
            pstmt.setString(2, id);

            return pstmt.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }


    /**
     * 특정 회원의 정보를 데이터베이스에서 삭제(회원탈퇴)합니다.
     *
     * @param id 탈퇴시킬 회원 아이디
     * @return 삭제 성공 시 true, 실패 시 false 반환
     */
    public boolean deleteMember(String id) {

        String sql = "DELETE FROM member " +
                     "WHERE id = ?";

        try (Connection conn = MariaDBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, id);

            return pstmt.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }
}