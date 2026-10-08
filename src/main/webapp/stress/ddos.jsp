<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Stress Lab - DDoS Tester</title>
  <!-- TailwindCSS 불러오기 -->
  <script src="https://cdn.tailwindcss.com"></script>
  <!-- 사용자 정의 CSS -->
  <link rel="stylesheet" href="<%=request.getContextPath()%>/css/styles.css">
  <!-- Font Awesome 아이콘 -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">
</head>

<script>
// JSP 컨텍스트 경로 가져오기
const contextPath = "<%=request.getContextPath()%>";

// UI 요소들을 담을 객체
const ui = { target:null, port:null, intensity:null, intensityValue:null, delay:null, randSource:null, status:null, log:null };

// 페이지 로드 시 실행
window.onload = () => {
  // 각 입력 요소와 상태/로그 영역 연결
  ui.target = document.getElementById("target");
  ui.port = document.getElementById("port");
  ui.intensity = document.getElementById("intensity");
  ui.intensityValue = document.getElementById("intensityValue");
  ui.delay = document.getElementById("delay");
  ui.randSource = document.getElementById("randSource");
  ui.status = document.getElementById("status");
  ui.log = document.getElementById("logArea");

  // 패킷 수 슬라이더 값 변경 이벤트
  ui.intensity.addEventListener("input", updateIntensity);

  // 공격 타입 버튼 클릭 이벤트
  document.querySelectorAll(".profile-btn").forEach(btn => btn.addEventListener("click", () => selectAttack(btn)));
};

// 상태 표시 변경 함수
function setStatus(text, css) {
  ui.status.textContent = text;
  ui.status.className = "text-sm px-4 py-1 rounded-full " + css;
}

// 로그 메시지 출력 함수
function setLog(message) { ui.log.textContent = message; }

// 패킷 수 슬라이더 값 표시 업데이트
function updateIntensity(e) { ui.intensityValue.textContent = e.target.value; }

// 공격 타입 선택 함수
function selectAttack(button) {
  document.querySelectorAll(".profile-btn").forEach(btn => btn.classList.remove("active"));
  button.classList.add("active");
}

// DDoS 공격 시작 함수
function startDDoS() {
  const target = ui.target.value.trim();
  if (!target) { alert("Target은 반드시 입력해야 합니다."); return; }

  // 선택된 공격 타입 가져오기
  const activeBtn = document.querySelector(".profile-btn.active");
  const attackType = activeBtn.dataset.command;

  // 서버로 보낼 데이터 준비
  const formData = new FormData();
  formData.append("t_gubun","ddos");
  formData.append("target",target);
  formData.append("attackType",attackType);
  if(ui.port.value) formData.append("port",ui.port.value);
  if(ui.intensity.value) formData.append("intensity",ui.intensity.value);
  if(ui.delay.value) formData.append("delay",ui.delay.value);
  if(ui.randSource.checked) formData.append("randSource","--rand-source");

  // 상태와 로그 변경
  setStatus("● Attacking...","scanning");
  setLog("hping3 공격 실행 중...");

  // 서버에 요청 보내기
  fetch(contextPath + "/stress",{ method:"POST", body:formData })
    .then(res=>res.text())
    .then(result=>{
      setLog(result); // 서버 응답 로그 출력
      setStatus("● Completed","completed"); // 완료 상태
    })
    .catch(err=>{
      setLog("ERROR : " + err); // 에러 로그 출력
      setStatus("● Error","error"); // 에러 상태
    });
}
</script>

<body>
<div class="flex h-screen">
  <%@ include file="sidebar.jsp" %> <!-- 사이드바 포함 -->
  <div class="flex-1 flex flex-col p-8 overflow-auto space-y-6">
    <!-- 페이지 제목 -->
    <div>
      <h2 class="text-4xl font-bold">DDoS / Load Test</h2>
      <p class="text-gray-400 mt-2">hping3 기반 네트워크 스트레스 테스트</p>
    </div>

    <!-- Target 입력 -->
    <div class="card">
      <label class="block text-sm text-gray-400 mb-2">Target IP / Domain</label>
      <input id="target" type="text" placeholder="예) 192.168.0.100" class="input-field">
    </div>

    <!-- 공격 타입 선택 -->
    <div>
      <h3 class="text-xl font-semibold mb-4">Attack Type</h3>
      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-5">
        <button type="button" class="profile-btn active" data-command="hping3 --syn">🗡️ SYN Flood<span>hping3 --syn</span></button>
        <button type="button" class="profile-btn" data-command="hping3 --udp">⚔️ UDP Flood<span>hping3 --udp</span></button>
        <button type="button" class="profile-btn" data-command="hping3 --icmp">💣 ICMP Flood<span>hping3 --icmp</span></button>
        <button type="button" class="profile-btn" data-command="hping3 --ack">🎭 ACK Flood<span>hping3 --ack</span></button>
      </div>
    </div>

    <!-- 옵션 및 로그 영역 -->
    <div class="grid grid-cols-1 lg:grid-cols-2 gap-8">
      <!-- 공격 옵션 -->
      <div class="card">
        <h3 class="text-xl font-semibold mb-6">Attack Options</h3>
        <div class="space-y-6">
          <div>
            <label class="block text-sm text-gray-400 mb-2">Destination Port</label>
            <input id="port" type="number" value="80" class="input-field">
          </div>
          <div>
            <label class="block text-sm text-gray-400 mb-2">Packet Count</label>
            <input id="intensity" type="range" min="10" max="10000" value="1000" class="w-full accent-red-500">
            <div id="intensityValue" class="text-right text-base font-mono mt-2 text-red-400">1000</div>
          </div>
          <div class="flex items-center gap-4">
            <input id="randSource" type="checkbox" class="w-5 h-5 accent-red-500">
            <label class="text-gray-300">Random Source IP</label>
          </div>
          <div>
            <label class="block text-sm text-gray-400 mb-2">Delay</label>
            <input id="delay" type="number" value="0" class="input-field">
          </div>
        </div>
      </div>

      <!-- 로그 출력 -->
      <div class="card flex flex-col">
        <div class="flex items-center justify-between mb-4">
          <h3 class="text-xl font-semibold"><i class="fas fa-terminal text-red-500"></i> Live Attack Log</h3>
          <span id="status" class="text-sm px-4 py-1 rounded-full ready">● Ready</span>
        </div>
        <pre id="logArea" class="ddos-log flex-1">hping3 공격 준비 중...</pre>
      </div>
    </div>

    <!-- 공격 시작 버튼 -->
    <button onclick="startDDoS()" class="start-btn mt-8">🚀 START DDoS ATTACK</button>

    <%@ include file="footer.jsp" %> <!-- 푸터 포함 -->
  </div>
</div>
</body>
</html>