package controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dao.MemberDao;
import dto.MemberDto;

@WebServlet("/member")
@MultipartConfig
public class member extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private MemberDao dao = new MemberDao();

    // GET 방식 요청 처리 (아이디 중복 검사 등)
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/plain;charset=UTF-8");

        String action = req.getParameter("action");

        if ("checkId".equals(action)) {

            checkId(req, resp);
            return;

        } else {

            resp.getWriter().print("잘못된 GET 요청입니다.");
            return;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        req.setCharacterEncoding("UTF-8");
        System.out.println("MemberController doPost 진입");

        String action = req.getParameter("action");
        System.out.println("action = " + action);
        
        resp.setContentType("text/plain;charset=UTF-8");

        if ("login".equals(action)) {

            login(req, resp);

        } else if ("insert".equals(action)) {

            insert(req, resp);

        } else if ("updateProfile".equals(action)) {

            updateProfile(req, resp);

        } else if ("updatePassword".equals(action)) {

        	updatePassword(req, resp);

        } else if ("deleteAccount".equals(action)) {

            deleteAccount(req, resp);

        } else {

            resp.getWriter().print("잘못된 요청입니다.");

        }
    }

    // 아이디 중복 체크
    private void checkId(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String id = req.getParameter("id");
        System.out.println("중복 체크할 아이디 : " + id);

        boolean isDuplicate = dao.isIdDuplicate(id); // MemberDao에 이 메서드가 구현되어 있어야 합니다.

        if (isDuplicate) {
            resp.getWriter().print("duplicated"); // 중복됨
        } else {
            resp.getWriter().print("available"); // 사용 가능
        }
    }

    // 로그인
    private void login(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String id = req.getParameter("id");
        String password = req.getParameter("password");
        
        System.out.println("Servlet id : " + id);
        System.out.println("Servlet password : " + password);

        MemberDto user = dao.login(id, password);

        if (user != null) {
            HttpSession session = req.getSession();
            session.setAttribute("loginUser", user); // 마이페이지 등과 키값(loginUser) 통일
            resp.getWriter().print("성공");
        } else {
            resp.getWriter().print("실패");
        }
    }

    // 회원가입
    private void insert(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String id = req.getParameter("id");
        String name = req.getParameter("name");
        String email = req.getParameter("email");
        String password = req.getParameter("password");

        if (password == null || password.trim().equals("")) {
            resp.getWriter().print("비밀번호가 전달되지 않았습니다.");
            return;
        }

        MemberDto user = new MemberDto();
        user.setId(id);
        user.setName(name);
        user.setEmail(email);
        user.setPassword(password);

        boolean success = dao.insert(user);
        if (success) {
            resp.getWriter().print("성공");
        } else {
            resp.getWriter().print("실패");
        }
    }
    
 // 개인정보 변경
    private void updateProfile(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("loginUser") == null) {
            resp.getWriter().print("로그인이 필요합니다.");
            return;
        }

        MemberDto loginUser =
                (MemberDto) session.getAttribute("loginUser");

        String id = loginUser.getId();
        String name = req.getParameter("name");
        String email = req.getParameter("email");

        if (name == null || name.trim().isEmpty()) {
            resp.getWriter().print("이름을 입력해주세요.");
            return;
        }

        if (email == null || email.trim().isEmpty()) {
            resp.getWriter().print("이메일을 입력해주세요.");
            return;
        }

        boolean success = dao.updateMember(
                id,
                name.trim(),
                email.trim()
        );

        if (success) {

            // 세션에 저장되어 있는 loginUser도 변경
            loginUser.setName(name.trim());
            loginUser.setEmail(email.trim());

            session.setAttribute("loginUser", loginUser);

            resp.getWriter().print("성공");

        } else {

            resp.getWriter().print("실패");
        }
    }
    
 // 비밀번호 변경
    private void updatePassword(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("loginUser") == null) {
            resp.getWriter().print("로그인이 필요합니다.");
            return;
        }

        MemberDto loginUser =
                (MemberDto) session.getAttribute("loginUser");

        String id = loginUser.getId();

        String currentPassword = req.getParameter("currentPassword");
        String newPassword = req.getParameter("newPassword");
        String newPasswordConfirm = req.getParameter("confirmPassword");

        if (currentPassword == null || currentPassword.trim().isEmpty()) {
            resp.getWriter().print("현재 비밀번호를 입력해주세요.");
            return;
        }

        if (newPassword == null || newPassword.trim().isEmpty()) {
            resp.getWriter().print("새 비밀번호를 입력해주세요.");
            return;
        }

        if (!newPassword.equals(newPasswordConfirm)) {
            resp.getWriter().print("새 비밀번호가 일치하지 않습니다.");
            return;
        }

        // 현재 비밀번호 확인
        boolean passwordCorrect =
                dao.checkPassword(id, currentPassword);

        if (!passwordCorrect) {
            resp.getWriter().print("현재 비밀번호가 올바르지 않습니다.");
            return;
        }

        // 새 비밀번호로 변경
        boolean success =
                dao.updatePassword(id, newPassword);

        if (success) {

            // 세션의 비밀번호도 변경
            loginUser.setPassword(newPassword);
            session.setAttribute("loginUser", loginUser);

            resp.getWriter().print("성공");

        } else {

            resp.getWriter().print("실패");
        }
    }
    
 // 회원탈퇴
    private void deleteAccount(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("loginUser") == null) {
            resp.getWriter().print("로그인이 필요합니다.");
            return;
        }

        MemberDto loginUser =
                (MemberDto) session.getAttribute("loginUser");

        String id = loginUser.getId();
        String password = req.getParameter("password");

        if (password == null || password.trim().isEmpty()) {
            resp.getWriter().print("비밀번호를 입력해주세요.");
            return;
        }

        // 비밀번호 확인
        boolean passwordCorrect =
                dao.checkPassword(id, password);

        if (!passwordCorrect) {
            resp.getWriter().print("비밀번호가 올바르지 않습니다.");
            return;
        }

        // 회원 삭제
        boolean success = dao.deleteMember(id);

        if (success) {

            // 세션 삭제
            session.invalidate();

            resp.getWriter().print("성공");

        } else {

            resp.getWriter().print("실패");
        }
    }
}