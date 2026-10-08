<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Stress Lab - Port Scanner</title>

  <script src="https://cdn.tailwindcss.com"></script>
  <link rel="stylesheet" href="css/styles.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">
</head>

<body>
<div class="flex h-screen">
  <!-- Sidebar -->
  <%@ include file="sidebar.jsp" %>

  <!-- Main Content -->
  <div class="flex-1 flex flex-col p-8 overflow-auto space-y-6">

    <!-- Title -->
    <div>
      <h2 class="text-4xl font-bold">Port Scan Test</h2>
      <p class="text-gray-400 mt-2">nmap을 이용한 네트워크 포트 스캔 테스트</p>
    </div>

    <!-- Live Log -->
    <div class="card flex-1 flex flex-col">
      <div class="flex items-center justify-between mb-4">
        <h3 class="text-xl font-semibold"><i class="fas fa-terminal text-red-500"></i> Live Scan Log</h3>
        <span id="status" class="text-sm px-4 py-1 rounded-full ready">● Ready</span>
      </div>
      <pre id="logArea" class="scan-log flex-1">
<%= request.getAttribute("scanResult") != null ? request.getAttribute("scanResult") : "스캔을 준비 중..." %>
      </pre>
    </div>

    <!-- Scan Form -->
    <form id="scanForm" method="post" action="<%= request.getContextPath() %>/stress">
      <input type="hidden" name="t_gubun" value="portscan">
      <input type="hidden" id="scanOption" name="scanOption">

      <!-- Target -->
      <div class="card">
        <label class="block text-sm text-gray-400 mb-2">Target IP or Network</label>
        <input name="target" class="input-field" placeholder="예: 192.168.0.0/24">
      </div>

      <!-- Scan Profile -->
      <div class="mt-6">
        <h3 class="text-xl font-semibold mb-4">Scan Profile</h3>
        <div class="grid grid-cols-1 md:grid-cols-3 gap-5">

          <button type="button" class="profile-btn" onclick="selectProfile('-T4 -A', this)">
            🔎 Full Scan<br><span class="text-sm text-gray-300">-T4 -A</span>
          </button>

          <button type="button" class="profile-btn" onclick="selectProfile('-sS -T4 -F', this)">
            ⚡ Fast Port Scan<br><span class="text-sm text-gray-300">-sS -T4 -F</span>
          </button>

          <button type="button" class="profile-btn" onclick="selectProfile('-sS -p- -T4', this)">
            📡 Full Port Scan<br><span class="text-sm text-gray-300">-sS -p- -T4</span>
          </button>

          <button type="button" class="profile-btn" onclick="selectProfile('-sV -sS -T4', this)">
            🪪 Service Version<br><span class="text-sm text-gray-300">-sV -sS -T4</span>
          </button>

          <button type="button" class="profile-btn" onclick="selectProfile('-O -T4', this)">
            💻 OS Detection<br><span class="text-sm text-gray-300">-O -T4</span>
          </button>

          <button type="button" class="profile-btn" onclick="selectProfile('--script vuln -T4', this)">
            🔑 Vulnerability Scan<br><span class="text-sm text-gray-300">--script vuln -T4</span>
          </button>

        </div>
      </div>

      <!-- Start Button -->
      <button id="scanBtn" type="submit" class="start-btn mt-6">
        👁️ START NMAP SCAN
      </button>
    </form>

    <%@ include file="footer.jsp" %>
  </div>
</div>

<script>
  // 프로필 선택
  function selectProfile(option, button) {
    document.getElementById("scanOption").value = option;
    document.querySelectorAll(".profile-btn").forEach(btn => btn.classList.remove("active"));
    button.classList.add("active");
  }

  // 상태 변경 함수
  function setStatus(text, cssClass) {
    const statusEl = document.getElementById("status");
    statusEl.textContent = text;
    statusEl.className = "text-sm px-4 py-1 rounded-full " + cssClass;
  }

  // 로그 변경 함수
  function setLog(message) {
    document.getElementById("logArea").textContent = message;
  }

  // 폼 제출 시 상태/로그 변경
  document.getElementById("scanForm").addEventListener("submit", () => {
    setStatus("● Scanning...", "scanning");
    setLog("스캔 시작 !!");
  });

  // JSP에서 scanResult가 있으면 Completed 상태로 변경
  <% if (request.getAttribute("scanResult") != null) { %>
    setStatus("● Completed", "completed");
  <% } %>
</script>
</body>
</html>