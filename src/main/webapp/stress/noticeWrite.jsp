<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>

<html lang="ko">

<head>

  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">

  <title>Stress Lab - Notice Write</title>

  <!-- TailwindCSS -->
  <script src="https://cdn.tailwindcss.com"></script>

  <!-- 사용자 정의 CSS -->
  <link rel="stylesheet"
        href="<%=request.getContextPath()%>/css/styles.css">

  <!-- Font Awesome -->
  <link rel="stylesheet"
        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">

</head>

<body>

<div class="flex h-screen">

  <!-- 사이드바 -->
  <%@ include file="sidebar.jsp" %>

  <!-- 메인 컨텐츠 영역 -->
  <div class="flex-1 flex flex-col p-8 overflow-auto space-y-3">

    <!-- 헤더 -->
    <div>

      <h2 class="text-4xl font-bold">
        Notice
      </h2>

      <p class="text-gray-400 mt-1">
        Stress Lab 공지사항 작성
      </p>

    </div>

    <!-- 공지 작성 폼 -->
    <form
      name="writeForm"
      method="post"
      action="<%=request.getContextPath()%>/notice"
      onsubmit="return validateForm();"
      class="card flex flex-col gap-4">

      <input type="hidden"
             name="t_gubun"
             value="write">

      <!-- 폼 제목 -->
      <div class="flex items-center gap-2">

        <i class="fas fa-pen text-red-500 text-xl"></i>

        <h3 class="text-xl font-semibold">
          공지 작성
        </h3>

      </div>

      <!-- 제목 + 작성자 입력 -->
      <div class="grid grid-cols-10 gap-4">

        <!-- 제목 입력 -->
        <div class="col-span-8">

          <label class="block text-gray-400 text-sm mb-1">
            제목
          </label>

          <input
            type="text"
            id="title"
            name="title"
            class="input-field"
            placeholder="공지 제목 입력">

        </div>

        <!-- 작성자 입력 -->
        <div class="col-span-2">

          <label class="block text-gray-400 text-sm mb-1">
            작성자
          </label>

          <input
            type="text"
            name="userName"
            value="${sessionScope.loginUser.name}"
            class="input-field"
            readonly="readonly">

        </div>

      </div>

      <!-- 내용 입력 -->
      <div class="flex flex-col">

        <label class="block text-gray-400 text-sm mb-1">
          내용
        </label>

        <textarea
          id="content"
          name="content"
          class="input-field resize-none"
          style="height:300px;"
          placeholder="공지 내용을 입력하세요."></textarea>

      </div>

      <!-- 버튼 영역 -->
      <div class="flex justify-end gap-3 mt-2">

        <!-- 취소 -->
        <button
          type="button"
          onclick="location.href='<%=request.getContextPath()%>/notice?t_gubun=notice'"
          class="h-10 w-24 rounded-xl text-white font-semibold text-sm hover:opacity-80 transition"
          style="background: var(--red);">

          <i class="fas fa-times"></i>
          취소

        </button>

        <!-- 등록 -->
        <button
          type="submit"
          class="h-10 w-24 rounded-xl text-white font-semibold text-sm hover:opacity-80 transition"
          style="background: var(--red);">

          <i class="fas fa-check"></i>
          등록

        </button>

      </div>

    </form>

    <!-- 푸터 -->
    <%@ include file="footer.jsp" %>

  </div>

</div>

<script>

// 폼 유효성 검사
function validateForm() {

  const title = document.getElementById("title").value.trim();
  const content = document.getElementById("content").value.trim();

  if (title === "") {

    alert("제목을 입력해주세요.");

    document.getElementById("title").focus();

    return false;
  }

  if (content === "") {

    alert("내용을 입력해주세요.");

    document.getElementById("content").focus();

    return false;
  }

  return true;
}

</script>

</body>

</html>