package controller;

import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import common.AttackResult;
import common.SSHUtil;
import service.DDoSService;
import service.PortScanService;

/**
 * Stress 서블릿
 * - /stress URL로 매핑됨
 * - GET 요청: JSP 페이지 라우팅
 * - POST 요청: PortScan, DDoS 실행 처리
 */
@WebServlet("/stress")
@MultipartConfig
public class stress extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // SSH 연결 유틸리티 (공용)
    private final SSHUtil ssh = new SSHUtil("192.168.0.25", 22, "claude", "1234");

    // 서비스 객체
    private final PortScanService portScanService = new PortScanService(ssh);
    private final DDoSService ddosService = new DDoSService(ssh);

    public stress() { super(); }

    /**
     * GET 요청 처리
     * - t_gubun 파라미터에 따라 JSP 페이지 선택 후 포워딩
     */
    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8"); // 요청 인코딩 설정
        String gubun = request.getParameter("t_gubun");
        if (gubun == null) gubun = "";

        String viewPage;
        switch (gubun) {
            case "ddos":     viewPage = "stress/ddos.jsp"; break;
            case "portscan": viewPage = "stress/portscan.jsp"; break;
            case "terminal": viewPage = "stress/terminal.jsp"; break;
            case "login":    viewPage = "stress/login.jsp"; break;
            case "dashboard":    viewPage = "stress/dashboard.jsp"; break;
            case "mypage":    viewPage = "stress/mypage.jsp"; break;
            default:         viewPage = "stress/index.jsp"; // 기본 페이지
        }

        RequestDispatcher rd = request.getRequestDispatcher(viewPage);
        rd.forward(request, response);
    }

    /**
     * POST 요청 처리
     * - t_gubun 값에 따라 PortScan 또는 DDoS 실행
     * - 결과를 JSP에 전달하거나 텍스트로 응답
     */
    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/plain;charset=UTF-8");

        String gubun = request.getParameter("t_gubun");

        try {
            AttackResult result;

            // PortScan 실행
            if ("portscan".equals(gubun)) {
                String target = request.getParameter("target");       // 대상 IP/네트워크
                String options = request.getParameter("scanOption");  // Nmap 옵션
                result = portScanService.execute(target, options);

                request.setAttribute("scanResult", result.getMessage());
                RequestDispatcher rd = request.getRequestDispatcher("stress/portscan.jsp");
                rd.forward(request, response);
                return;
            }

            // DDoS 실행
            else if ("ddos".equals(gubun)) {
                String target = request.getParameter("target");         // 공격 대상
                String attackType = request.getParameter("attackType"); // 공격 타입
                String port = request.getParameter("port");             // 대상 포트
                String intensity = request.getParameter("intensity");   // 패킷 수
                String delay = request.getParameter("delay");           // 지연 시간
                String randSource = request.getParameter("randSource"); // 랜덤 소스 IP 여부

                result = ddosService.execute(attackType, target, port, intensity, delay, randSource);

                request.setAttribute("attackResult", result.getMessage());
                RequestDispatcher rd = request.getRequestDispatcher("stress/ddos.jsp");
                rd.forward(request, response);
                return;
            }

            // 지원하지 않는 요청
            else {
                result = new AttackResult(false, "지원하지 않는 요청입니다.");
            }

            response.getWriter().print(result.getMessage());

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().print("ERROR : " + e.getMessage());
        }
    }
}
