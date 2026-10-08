package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import common.MariaDBConnection;
import dto.NoticeDto;

public class NoticeDao {

    private NoticeDto mapResultSet(ResultSet rs) throws SQLException {

        NoticeDto dto = new NoticeDto();

        dto.setNoticeId(rs.getInt("notice_id"));
        dto.setWriterId(rs.getString("writer_id"));
        dto.setWriterName(rs.getString("writer_name"));
        dto.setTitle(rs.getString("title"));
        dto.setContent(rs.getString("content"));
        dto.setViewCount(rs.getInt("view_count"));
        dto.setCreatedAt(rs.getTimestamp("created_at"));
        dto.setUpdatedAt(rs.getTimestamp("updated_at"));

        return dto;
    }


    // 공지사항 목록 조회
    public List<NoticeDto> getNoticeList(int start, int pageSize) {

        String sql = """
            SELECT n.notice_id, n.writer_id, m.name AS writer_name,
                   n.title, n.content, n.view_count,
                   n.created_at, n.updated_at
            FROM notice n
            JOIN member m ON n.writer_id = m.id
            ORDER BY n.notice_id DESC
            LIMIT ?, ?
            """;

        List<NoticeDto> list = new ArrayList<>();

        try (Connection con = MariaDBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, start);
            ps.setInt(2, pageSize);

            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {
                    list.add(mapResultSet(rs));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }


    // 공지사항 상세 조회
    public NoticeDto getNotice(int noticeId) {

        String sql = """
            SELECT n.notice_id, n.writer_id, m.name AS writer_name,
                   n.title, n.content, n.view_count,
                   n.created_at, n.updated_at
            FROM notice n
            JOIN member m ON n.writer_id = m.id
            WHERE n.notice_id = ?
            """;

        try (Connection con = MariaDBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, noticeId);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    return mapResultSet(rs);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }


    // 조회수 증가
    public boolean increaseViewCount(int noticeId) {

        String sql =
            "UPDATE notice " +
            "SET view_count = view_count + 1 " +
            "WHERE notice_id = ?";

        try (Connection con = MariaDBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, noticeId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }


    // 공지사항 작성
    public int insertNotice(NoticeDto dto) {

        String sql =
            "INSERT INTO notice (writer_id, title, content) " +
            "VALUES (?, ?, ?)";

        try (
            Connection con = MariaDBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(
                sql,
                Statement.RETURN_GENERATED_KEYS
            )
        ) {

            ps.setString(1, dto.getWriterId());
            ps.setString(2, dto.getTitle());
            ps.setString(3, dto.getContent());

            int result = ps.executeUpdate();

            if (result == 0) {
                return 0;
            }

            try (ResultSet rs = ps.getGeneratedKeys()) {

                if (rs.next()) {
                    return rs.getInt(1);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }


    // 공지사항 수정
    public boolean updateNotice(NoticeDto dto) {

        String sql =
            "UPDATE notice " +
            "SET title = ?, content = ? " +
            "WHERE notice_id = ?";

        try (Connection con = MariaDBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, dto.getTitle());
            ps.setString(2, dto.getContent());
            ps.setInt(3, dto.getNoticeId());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }


    // 공지사항 삭제
    public boolean deleteNotice(int noticeId) {

        String sql =
            "DELETE FROM notice " +
            "WHERE notice_id = ?";

        try (Connection con = MariaDBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, noticeId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }


    // 전체 공지사항 개수 조회
    public int getNoticeCount() {

        String sql = "SELECT COUNT(*) FROM notice";

        try (Connection con = MariaDBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }


    // 공지사항 검색
    public List<NoticeDto> searchNotice(
            String searchType,
            String keyword,
            int start,
            int pageSize) {

        String column =
            "content".equals(searchType)
            ? "n.content"
            : "n.title";

        String sql =
            "SELECT n.notice_id, n.writer_id, m.name AS writer_name, " +
            "n.title, n.content, n.view_count, " +
            "n.created_at, n.updated_at " +
            "FROM notice n " +
            "JOIN member m ON n.writer_id = m.id " +
            "WHERE " + column + " LIKE ? " +
            "ORDER BY n.notice_id DESC " +
            "LIMIT ?, ?";

        List<NoticeDto> list = new ArrayList<>();

        try (Connection con = MariaDBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, "%" + keyword + "%");
            ps.setInt(2, start);
            ps.setInt(3, pageSize);

            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {
                    list.add(mapResultSet(rs));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }


    // 검색 결과 개수 조회
    public int getSearchNoticeCount(
            String searchType,
            String keyword) {

        String column =
            "content".equals(searchType)
            ? "n.content"
            : "n.title";

        String sql =
            "SELECT COUNT(*) " +
            "FROM notice n " +
            "WHERE " + column + " LIKE ?";

        try (Connection con = MariaDBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, "%" + keyword + "%");

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    return rs.getInt(1);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }
}