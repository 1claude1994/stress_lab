<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isELIgnored="false"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <!-- 기본 메타 정보 -->
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Stress Lab - Kali Terminal</title>

  <!-- TailwindCSS 및 외부 스타일 -->
  <script src="https://cdn.tailwindcss.com"></script>
  <link rel="stylesheet" href="css/styles.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">
</head>
<body>
<div class="flex h-screen">

  <!-- 사이드바 -->
  <%@ include file="sidebar.jsp"%>

  <!-- 메인 컨텐츠 -->
  <div class="flex-1 flex flex-col p-8 overflow-auto space-y-6">

    <!-- 타이틀 -->
    <div>
      <h2 class="text-4xl font-bold">Kali Terminal</h2>
      <p class="text-gray-400 mt-2">관리자용 실시간 SSH 원격 터미널</p>
    </div>

    <!-- 터미널 카드 -->
    <div class="card flex-1 flex flex-col">

      <!-- 헤더 -->
      <div class="flex items-center justify-between mb-4">
        <h3 class="text-xl font-semibold flex items-center gap-2">
          <i class="fas fa-terminal text-red-500"></i> Admin Terminal
        </h3>
        <span id="status">● Connecting...</span>
      </div>

      <!-- 로그 출력 영역 -->
      <pre id="logArea" class="scan-log flex-1 p-4">
Kali에 연결 중...
      </pre>

      <!-- 명령어 입력 -->
      <div class="flex items-center gap-3 mt-4">
        <span class="text-green-400 font-mono">$</span>
        <input id="commandInput" class="input-field flex-1 font-mono"
               type="text" placeholder="명령어 입력 후 Enter" autofocus>
      </div>
    </div>
    
    <!-- 푸터 -->
    <%@ include file="footer.jsp" %>
  
  </div>
</div>

<!-- WebSocket 및 터미널 제어 스크립트 -->
<script>
const contextPath = "<%=request.getContextPath()%>"; // JSP Context Path
let socket = null; // WebSocket 객체

// 터미널 요소 참조
const terminal = {
  status: null, // 상태 표시
  log: null,    // 로그 출력 영역
  input: null   // 명령어 입력창
};

// 페이지 로드 시 초기화
window.onload = () => {
  terminal.status = document.getElementById("status");
  terminal.log = document.getElementById("logArea");
  terminal.input = document.getElementById("commandInput");

  // Enter 키 입력 시 명령어 전송
  terminal.input.addEventListener("keypress", e => {
    if (e.key === "Enter") sendCommand();
  });

  connectWebSocket();
};

// WebSocket 연결
function connectWebSocket() {
  const protocol = location.protocol === "https:" ? "wss://" : "ws://";
  const url = protocol + location.host + contextPath + "/terminal";
  socket = new WebSocket(url);

  socket.onopen = onOpen;
  socket.onmessage = onMessage;
  socket.onerror = onError;
  socket.onclose = onClose;
}

// WebSocket 이벤트 핸들러
function onOpen() {
  changeStatus("● Connected", "connected");
  appendLog("[INFO] WebSocket 연결", "text-green-400");
}

function onMessage(event) {
  appendLog(event.data);
}

function onError() {
  changeStatus("● Error", "error");
  appendLog("[ERROR] WebSocket 에러", "text-red-500");
}

function onClose() {
  changeStatus("● Disconnected", "error");
  appendLog("[INFO] 연결 종료", "text-yellow-400");
}

// 명령어 전송
function sendCommand() {
  const command = terminal.input.value.trim();
  if (command === "") return;

  // clear 명령어 처리
  if (command === "clear") {
    clearTerminal();
    terminal.input.value = "";
    return;
  }

  appendLog("$ " + command, "text-blue-400");

  if (socket && socket.readyState === WebSocket.OPEN) {
    socket.send(command);
  } else {
    appendLog("[ERROR] WebSocket이 연결 되지 않았습니다", "text-red-500");
  }

  terminal.input.value = "";
}

// 로그 출력
function appendLog(message, css = "") {
  const span = document.createElement("span");
  span.className = css;
  span.innerHTML = message.replace(/\n/g, "<br>");
  terminal.log.appendChild(span);
  terminal.log.appendChild(document.createElement("br"));
  terminal.log.scrollTop = terminal.log.scrollHeight; // 자동 스크롤
}

// 상태 변경
function changeStatus(text, css) {
  terminal.status.innerText = text;
  terminal.status.className = css;
}

// 터미널 초기화
function clearTerminal() {
  terminal.log.innerHTML = "Terminal Cleared.<br>";
}
</script>
</body>
</html>