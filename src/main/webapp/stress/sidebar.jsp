<%@page import="dto.MemberDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    // 세션에서 로그인 사용자 정보 가져오기
    MemberDto loginUser = (MemberDto)session.getAttribute("loginUser");
%>

<!-- 사이드바 -->
<div class="sidebar">
    <!-- 로고/타이틀 -->
    <h1 class="text-3xl font-bold text-red-500 mb-8 flex items-center gap-3">
        <i class="fas fa-bolt"></i> Stress Lab
    </h1>

    <!-- 네비게이션 메뉴 -->
    <nav class="space-y-2">
        <a href="<%=request.getContextPath()%>/stress?t_gubun=dashboard" class="nav-item">Dash board</a>
        <a href="<%=request.getContextPath()%>/notice?t_gubun=notice" class="nav-item">Notice</a>
        <a href="<%=request.getContextPath()%>/stress?t_gubun=ddos" class="nav-item">DDoS Attack</a>
        <a href="<%=request.getContextPath()%>/stress?t_gubun=portscan" class="nav-item">Port Scanner</a>
        <a href="<%=request.getContextPath()%>/stress?t_gubun=terminal" class="nav-item">Terminal</a>
    </nav>

    <!-- 사용자 영역 -->
    <div class="sidebar-user">
            <!-- 로그인 된 경우: 프로필 + 로그아웃 -->
            <div class="sidebar-profile">
                <i class="fas fa-user-circle"></i>
                <span><%= loginUser.getName() %> 님</span>
            </div>
            <a href="<%=request.getContextPath()%>/stress?t_gubun=mypage" class="sidebar-logout">
                <i class="fa-solid fa-gear"></i> MyPage
            </a>
            <a href="<%=request.getContextPath()%>/stress?t_gubun=index" class="sidebar-logout">
                <i class="fas fa-sign-out-alt"></i> Logout
            </a>
    </div>
</div>