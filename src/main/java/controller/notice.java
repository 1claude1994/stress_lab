package controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dao.NoticeDao;
import dto.MemberDto;
import dto.NoticeDto;

@WebServlet("/notice")
public class notice extends HttpServlet {

    private NoticeDao dao;

    @Override
    public void init() throws ServletException {
        dao = new NoticeDao();
    }


    // =========================================================
    // GET
    // =========================================================
    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String gubun =
            request.getParameter("t_gubun");

        if (gubun == null) {
            gubun = "notice";
        }


        // =====================================================
        // 공지사항 목록
        // =====================================================
        if ("notice".equals(gubun)) {

            String searchType =
                request.getParameter("searchType");

            String keyword =
                request.getParameter("keyword");


            int page = 1;
            int pageSize = 5;

            String pageStr =
                request.getParameter("page");

            if (pageStr != null &&
                !pageStr.trim().isEmpty()) {

                try {
                    page = Integer.parseInt(pageStr);
                } catch (NumberFormatException e) {
                    page = 1;
                }
            }

            if (page < 1) {
                page = 1;
            }


            boolean isSearch =
                keyword != null &&
                !keyword.trim().isEmpty();


            int noticeCount =
                isSearch
                    ? dao.getSearchNoticeCount(
                        searchType,
                        keyword.trim()
                      )
                    : dao.getNoticeCount();


            int totalPages =
                (noticeCount + pageSize - 1)
                / pageSize;


            if (totalPages == 0) {
                page = 1;
            } else if (page > totalPages) {
                page = totalPages;
            }


            int start =
                (page - 1) * pageSize;


            List<NoticeDto> noticeList =
                isSearch
                    ? dao.searchNotice(
                        searchType,
                        keyword.trim(),
                        start,
                        pageSize
                      )
                    : dao.getNoticeList(
                        start,
                        pageSize
                      );


            request.setAttribute(
                "noticeList",
                noticeList
            );

            request.setAttribute(
                "noticeCount",
                noticeCount
            );

            request.setAttribute(
                "page",
                page
            );

            request.setAttribute(
                "pageSize",
                pageSize
            );

            request.setAttribute(
                "totalPages",
                totalPages
            );

            request.setAttribute(
                "searchType",
                searchType
            );

            request.setAttribute(
                "keyword",
                keyword
            );


            request.getRequestDispatcher(
                "/stress/notice.jsp"
            ).forward(request, response);

            return;
        }


        // =====================================================
        // 공지사항 작성 페이지
        // =====================================================
        if ("write".equals(gubun)) {

            HttpSession session =
                request.getSession(false);


            if (session == null ||
                session.getAttribute("loginUser") == null) {

                response.sendRedirect(
                    request.getContextPath()
                    + "/notice?t_gubun=notice"
                );

                return;
            }


            request.getRequestDispatcher(
                "/stress/noticeWrite.jsp"
            ).forward(request, response);

            return;
        }


        // =====================================================
        // 공지사항 수정 페이지
        // =====================================================
        if ("edit".equals(gubun)) {

            String noticeIdStr =
                request.getParameter("notice_id");


            if (noticeIdStr == null ||
                noticeIdStr.trim().isEmpty()) {

                response.sendRedirect(
                    request.getContextPath()
                    + "/notice?t_gubun=notice"
                );

                return;
            }


            try {

                int noticeId =
                    Integer.parseInt(noticeIdStr);


                NoticeDto notice =
                    dao.getNotice(noticeId);


                if (notice == null) {

                    response.sendRedirect(
                        request.getContextPath()
                        + "/notice?t_gubun=notice"
                    );

                    return;
                }


                request.setAttribute(
                    "notice",
                    notice
                );


                request.getRequestDispatcher(
                    "/stress/noticeEdit.jsp"
                ).forward(request, response);

            } catch (NumberFormatException e) {

                response.sendRedirect(
                    request.getContextPath()
                    + "/notice?t_gubun=notice"
                );
            }

            return;
        }


        // =====================================================
        // 공지사항 상세보기
        // =====================================================
        if ("view".equals(gubun)) {

            String noticeIdStr =
                request.getParameter("notice_id");


            if (noticeIdStr == null ||
                noticeIdStr.trim().isEmpty()) {

                response.sendRedirect(
                    request.getContextPath()
                    + "/notice?t_gubun=notice"
                );

                return;
            }


            try {

                int noticeId =
                    Integer.parseInt(noticeIdStr);


                // 조회수 증가
                dao.increaseViewCount(noticeId);


                // 공지사항 조회
                NoticeDto notice =
                    dao.getNotice(noticeId);


                if (notice == null) {

                    response.sendRedirect(
                        request.getContextPath()
                        + "/notice?t_gubun=notice"
                    );

                    return;
                }


                request.setAttribute(
                    "notice",
                    notice
                );


                request.getRequestDispatcher(
                    "/stress/noticeView.jsp"
                ).forward(request, response);


            } catch (NumberFormatException e) {

                response.sendRedirect(
                    request.getContextPath()
                    + "/notice?t_gubun=notice"
                );
            }

            return;
        }
    }


    // =========================================================
    // POST
    // =========================================================
    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String gubun =
            request.getParameter("t_gubun");


        // =====================================================
        // 공지사항 작성
        // =====================================================
        if ("write".equals(gubun)) {

            HttpSession session =
                request.getSession(false);


            if (session == null ||
                session.getAttribute("loginUser") == null) {

                response.sendRedirect(
                    request.getContextPath()
                    + "/stress/login.jsp"
                );

                return;
            }


            MemberDto user =
                (MemberDto) session.getAttribute(
                    "loginUser"
                );


            String title =
                request.getParameter("title");

            String content =
                request.getParameter("content");


            NoticeDto notice =
                new NoticeDto();

            notice.setWriterId(
                user.getId()
            );

            notice.setTitle(
                title
            );

            notice.setContent(
                content
            );


            int noticeId =
                dao.insertNotice(notice);


            if (noticeId == 0) {

                response.sendRedirect(
                    request.getContextPath()
                    + "/notice?t_gubun=write&error=1"
                );

                return;
            }


            response.sendRedirect(
                request.getContextPath()
                + "/notice?t_gubun=notice"
            );

            return;
        }


        // =====================================================
        // 공지사항 수정
        // =====================================================
        if ("edit".equals(gubun)) {

            String noticeIdStr =
                request.getParameter("notice_id");


            if (noticeIdStr == null ||
                noticeIdStr.trim().isEmpty()) {

                response.sendRedirect(
                    request.getContextPath()
                    + "/notice?t_gubun=notice"
                );

                return;
            }


            try {

                int noticeId =
                    Integer.parseInt(noticeIdStr);


                String title =
                    request.getParameter("title");

                String content =
                    request.getParameter("content");


                NoticeDto notice =
                    new NoticeDto();

                notice.setNoticeId(
                    noticeId
                );

                notice.setTitle(
                    title
                );

                notice.setContent(
                    content
                );


                boolean result =
                    dao.updateNotice(notice);


                if (result) {

                    response.sendRedirect(
                        request.getContextPath()
                        + "/notice?t_gubun=view&notice_id="
                        + noticeId
                    );

                } else {

                    response.sendRedirect(
                        request.getContextPath()
                        + "/notice?t_gubun=edit&notice_id="
                        + noticeId
                        + "&error=1"
                    );
                }


            } catch (NumberFormatException e) {

                response.sendRedirect(
                    request.getContextPath()
                    + "/notice?t_gubun=notice"
                );
            }

            return;
        }


        // =====================================================
        // 공지사항 삭제
        // =====================================================
        if ("delete".equals(gubun)) {

            String noticeIdStr =
                request.getParameter("notice_id");


            if (noticeIdStr == null ||
                noticeIdStr.trim().isEmpty()) {

                response.sendRedirect(
                    request.getContextPath()
                    + "/notice?t_gubun=notice"
                );

                return;
            }


            try {

                int noticeId =
                    Integer.parseInt(noticeIdStr);


                dao.deleteNotice(noticeId);


                response.sendRedirect(
                    request.getContextPath()
                    + "/notice?t_gubun=notice"
                );


            } catch (NumberFormatException e) {

                response.sendRedirect(
                    request.getContextPath()
                    + "/notice?t_gubun=notice"
                );
            }

            return;
        }
    }
}