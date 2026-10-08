<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Stress Lab - Main</title>

  <script src="https://cdn.tailwindcss.com"></script>
  <link rel="stylesheet" href="css/styles.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">
</head>

<body class="min-h-screen flex flex-col">

  <!-- 움직이는 배경 -->
  <div class="hero-bg"></div>

  <!-- 메인 컨텐츠 (화면을 꽉 채우되 Footer 공간 확보) -->
  <div class="hero-content flex-1 flex flex-col justify-center items-center px-4">

    <!-- 로고 + 타이틀 -->
    <div class="title-wrap">
      <i class="fas fa-bolt text-red-500 text-5xl md:text-6xl"></i>
      <h1 class="hero-title">Stress Lab</h1>
    </div>

    <p class="hero-subtitle">
      네트워크 · 포트 · 취약점 스캔을 한 곳에서<br>
      강력하고 직관적인 보안 테스트 플랫폼
    </p>

    <!-- 로그인 시작 버튼 -->
    <a href="<%=request.getContextPath()%>/stress?t_gubun=login">
      <button class="start-login-btn">
        <i class="fa-solid fa-right-to-bracket mr-2"></i>
        로그인 시작하기
      </button>
    </a>

    <!-- 하단 기능 소개 -->
    <div class="feature-list mt-10">
      <div class="feature-item">
        <i class="fa-solid fa-network-wired"></i>
        <h4>Port Scanner</h4>
        <p>Nmap 기반 고속 스캔</p>
      </div>
      <div class="feature-item">
        <i class="fa-solid fa-shield-halved"></i>
        <h4>Vulnerability</h4>
        <p>취약점 자동 탐지</p>
      </div>
      <div class="feature-item">
        <i class="fa-solid fa-terminal"></i>
        <h4>Live Log</h4>
        <p>실시간 결과 확인</p>
      </div>
    </div>
  </div>

  <!-- Footer (스크롤 없이 바로 보임) -->
  <%@ include file="footer.jsp" %>

</body>
</html>