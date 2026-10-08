package dto;

import java.sql.Timestamp;

public class NoticeDto {
    private int noticeId;
    private String writerId;
    private String writerName;
    private String title;
    private String content;
    private int viewCount;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    public NoticeDto() {}

    // Getter & Setter
    public int getNoticeId() { return noticeId; }
    public void setNoticeId(int noticeId) { this.noticeId = noticeId; }
    public String getWriterId() { return writerId; }
    public void setWriterId(String writerId) { this.writerId = writerId; }
    public String getWriterName() { return writerName; }
    public void setWriterName(String writerName) { this.writerName = writerName; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
    public int getViewCount() { return viewCount; }
    public void setViewCount(int viewCount) { this.viewCount = viewCount; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }
}