<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <!-- 기본 메타 정보 -->
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>로그인 / 회원가입</title>

  <!-- TailwindCSS -->
  <script src="https://cdn.tailwindcss.com"></script>

  <!-- 사용자 정의 CSS -->
  <link rel="stylesheet" href="css/styles.css">

  <!-- Font Awesome 아이콘 -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">

  <!-- 로그인/회원가입 관련 스크립트 -->
  <script>
    const contextPath = "<%=request.getContextPath()%>";
    
    let idChecked = false;
    let idAvailable = false;

    // 아이디 중복 확인
    function checkIdDuplicate() {
      const idInput = document.getElementById("insertId");
      const checkBtn = document.getElementById("checkBtn");
      const id = idInput.value.trim();

      // 아이디 입력 여부 검사
      if (id === "") {
        alert("아이디를 입력해주세요.");
        idInput.focus();
        return;
      }

      // 서버로 중복 확인 요청
      fetch(contextPath + "/member?action=checkId&id=" + encodeURIComponent(id), {
        method: "GET"
      })
      .then(res => res.text())
      .then(result => {
        if (result.includes("duplicated")) {
          idChecked = true;
          idAvailable = false;

          alert("이미 사용 중인 아이디입니다.");

          checkBtn.textContent = "사용불가";
          checkBtn.style.color = "var(--red)";

          idInput.focus();
        } else {
          idChecked = true;
          idAvailable = true;

          alert("사용 가능한 아이디입니다.");

          checkBtn.textContent = "사용가능";
          checkBtn.style.color = "var(--green)";
        }
      })
      .catch(err => {
        idChecked = false;
        idAvailable = false;
        alert("에러 발생 : " + err);
      });
    }

    // 회원가입 처리
    function insert() {
      const form = document.getElementById("insertForm");
      const formData = new FormData(form);

      const idInput = form.querySelector('[name="id"]');
      const nameInput = form.querySelector('[name="name"]');
      const emailInput = form.querySelector('[name="email"]');
      const passwordInput = form.querySelector('[name="password"]');
      const passwordConfirmInput = form.querySelector('[name="passwordConfirm"]');

      const id = idInput.value.trim();
      const name = nameInput.value.trim();
      const email = emailInput.value.trim();
      const password = passwordInput.value;
      const passwordConfirm = passwordConfirmInput.value;

      // 이름 공백 검사
      if (name === "") {
        alert("이름을 입력해주세요.");
        nameInput.focus();
        return;
      }
      
      // 아이디 공백 검사
      if (id === "") {
        alert("아이디를 입력해주세요.");
        idInput.focus();
        return;
      }

      // 아이디 중복 확인 여부 검사
      if (!idChecked) {
        alert("아이디 중복확인을 해주세요.");
        idInput.focus();
        return;
      }

      // 아이디 사용 가능 여부 검사
      if (!idAvailable) {
        alert("사용할 수 없는 아이디입니다.");
        idInput.focus();
        return;
      }

      // 이메일 공백 검사
      if (email === "") {
        alert("이메일을 입력해주세요.");
        emailInput.focus();
        return;
      }

      // 비밀번호 공백 검사
      if (password.trim() === "") {
        alert("비밀번호를 입력해주세요.");
        passwordInput.focus();
        return;
      }

      // 비밀번호 확인 공백 검사
      if (passwordConfirm.trim() === "") {
        alert("비밀번호 확인을 입력해주세요.");
        passwordConfirmInput.focus();
        return;
      }

      // 비밀번호 일치 여부 검사
      if (password !== passwordConfirm) {
        alert("비밀번호가 일치하지 않습니다.");
        passwordConfirmInput.focus();
        return;
      }

      // trim된 값 적용
      formData.set("id", id);
      formData.set("name", name);
      formData.set("email", email);
      formData.append("action", "insert");

      // 서버로 회원가입 요청 전송
      fetch(contextPath + "/member", {
        method: "POST",
        body: formData
      })
      .then(res => res.text())
      .then(result => {
        if (result.includes("성공")) {
          alert("회원가입 성공");
          showForm("login");
        } else {
          alert("회원가입 실패 : " + result);
        }
      })
      .catch(err => alert("에러 발생 : " + err));
    }

    // 로그인 처리
    function login() {
      const form = document.getElementById("loginForm");
      const formData = new FormData(form);

      const idInput = form.querySelector('[name="id"]');
      const passwordInput = form.querySelector('[name="password"]');

      const id = idInput.value.trim();
      const password = passwordInput.value;

      // 아이디 공백 검사
      if (id === "") {
        alert("아이디를 입력해주세요.");
        idInput.focus();
        return;
      }

      // 비밀번호 공백 검사
      if (password.trim() === "") {
        alert("비밀번호를 입력해주세요.");
        passwordInput.focus();
        return;
      }

      // trim된 아이디 적용 및 액션 추가
      formData.set("id", id);
      formData.append("action", "login");

      // 서버로 로그인 요청 전송
      fetch(contextPath + "/member", {
        method: "POST",
        body: formData
      })
      .then(res => res.text())
      .then(result => {
        if (result.includes("성공")) {
          alert("로그인 성공");
          location.href = contextPath + "/stress?t_gubun=dashboard";
        } else {
          alert("아이디 또는 비밀번호가 틀렸습니다.");
          idInput.focus();
        }
      })
      .catch(err => alert("에러 발생 : " + err));
    }

    // 폼 전환 (로그인/회원가입)
    function showForm(type) {
      document.querySelectorAll(".tab-btn").forEach(btn => btn.classList.remove("active"));
      document.querySelectorAll(".form-section").forEach(form => form.classList.remove("active"));

      if (type === "login") {
        document.getElementById("loginForm").classList.add("active");
        document.querySelectorAll(".tab-btn")[0].classList.add("active");
      } else {
        document.getElementById("insertForm").classList.add("active");
        document.querySelectorAll(".tab-btn")[1].classList.add("active");
      }
    }

    // 메인으로 이동
    function goHome() {
      location.href = "stress?t_gubun=index";
    }
  </script>
</head>
<body class="min-h-screen flex flex-col">
  <!-- 배경 -->
  <div class="hero-bg"></div>

  <!-- 메인 컨텐츠 영역 -->
  <div class="hero-content flex-1 flex flex-col justify-center items-center">
    <div class="auth-card w-full max-w-md">
      
      <!-- 타이틀 -->
      <div class="auth-title">환영합니다</div>
      <div class="auth-subtitle">계정에 로그인하거나 새로 가입하세요</div>

      <!-- 탭 메뉴 (로그인 / 회원가입 전환) -->
      <div class="tab-menu">
        <button type="button" class="tab-btn active" onclick="showForm('login')">로그인</button>
        <button type="button" class="tab-btn" onclick="showForm('insert')">회원가입</button>
      </div>

      <!-- 로그인 폼 -->
      <form id="loginForm" class="form-section active">
        <!-- 아이디 입력 그룹 -->
        <div class="input-group">
          <label>아이디</label>
          <input type="text" name="id" class="input-field" placeholder="아이디를 입력하세요">
        </div>
        
        <!-- 비밀번호 입력 그룹 -->
        <div class="input-group">
          <label>비밀번호</label>
          <input type="password" name="password" class="input-field" placeholder="비밀번호를 입력하세요">
        </div>

        <!-- 로그인 버튼 -->
        <button type="button" class="auth-btn" onclick="login()">로그인</button>

        <!-- 메인으로 돌아가기 버튼 -->
        <button type="button" class="home-btn" onclick="goHome()">
          <i class="fas fa-home"></i> 메인으로 돌아가기
        </button>

        <!-- 추가 링크 (비밀번호 찾기 등) -->
        <div class="extra-links">
          <a href="#">비밀번호를 잊으셨나요?</a>
        </div>
      </form>

      <!-- 회원가입 폼 -->
      <form id="insertForm" class="form-section">
        <div class="flex flex-col">
          
          <!-- 아이디 + 중복확인 입력 그룹 -->
          <div class="input-group">
            <label>아이디</label>
            <div class="flex gap-2">
              <input type="text" name="id" id="insertId" class="input-field flex-1" placeholder="사용할 아이디">
              <button type="button" id="checkBtn" onclick="checkIdDuplicate()" class="h-10 px-4 rounded-xl text-white font-semibold text-sm transition" style="background: var(--dark); border: 1px solid var(--border);">
                중복확인
              </button>
            </div>
            <span id="idCheckMessage" class="text-sm mt-1 block"></span>
          </div>

          <!-- 이름 입력 그룹 -->
          <div class="input-group">
            <label>이름</label>
            <input type="text" name="name" class="input-field" placeholder="이름">
          </div>

          <!-- 이메일 입력 그룹 -->
          <div class="input-group">
            <label>이메일</label>
            <input type="email" name="email" class="input-field" placeholder="example@email.com">
          </div>

          <!-- 비밀번호 + 비밀번호 확인 입력 그룹 -->
          <div class="grid grid-cols-2 gap-4">
            <!-- 비밀번호 -->
            <div class="input-group">
              <label>비밀번호</label>
              <input type="password" name="password" class="input-field" placeholder="비밀번호">
            </div>

            <!-- 비밀번호 확인 -->
            <div class="input-group">
              <label>비밀번호 확인</label>
              <input type="password" name="passwordConfirm" class="input-field" placeholder="비밀번호 다시 입력">
            </div>
          </div>

        </div>

        <!-- 회원가입 버튼 -->
        <button type="button" class="auth-btn" onclick="insert()">
          회원가입
        </button>

        <!-- 메인으로 돌아가기 버튼 -->
        <button type="button" class="home-btn" onclick="goHome()">
          <i class="fas fa-home"></i> 메인으로 돌아가기
        </button>
      </form>

    </div>
  </div>

  <!-- 푸터 포함 -->
  <%@ include file="footer.jsp" %>
</body>
</html>