<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>  
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <!-- 기본 메타 정보 -->
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Stress Lab - Notice</title>

    <!-- TailwindCSS -->
    <script src="https://cdn.tailwindcss.com"></script>

    <!-- 사용자 정의 CSS -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/styles.css">

    <!-- Font Awesome 아이콘 -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">
</head>
<body>
<div class="flex h-screen">

    <!-- 사이드바 포함 -->
    <%@ include file="sidebar.jsp" %>

    <!-- 메인 컨텐츠 영역 -->
    <div class="flex-1 flex flex-col p-8 overflow-auto space-y-6">

        <!-- 상단 타이틀 -->
        <div>
            <h2 class="text-4xl font-bold">Notice</h2>
            <p class="text-gray-400 mt-2">Stress Lab 공지사항</p>
        </div>

        <!-- 검색 영역 -->
        <form method="get"
              action="${pageContext.request.contextPath}/notice"
              class="flex justify-end items-center gap-3">

            <input type="hidden" name="t_gubun" value="notice">

            <div class="custom-select-wrap">
                <select class="custom-select" name="searchType">
                    <option value="title" ${searchType == 'title' ? 'selected' : ''}>제목</option>
                    <option value="content" ${searchType == 'content' ? 'selected' : ''}>내용</option>
                </select>
                <i class="fas fa-chevron-down select-icon"></i>
            </div>

            <input class="input-field h-10 w-72 text-sm rounded-xl"
                   name="keyword"
                   value="${keyword}"
                   placeholder="검색어 입력">

            <button type="submit"
                    class="h-10 w-24 rounded-xl text-white font-semibold text-sm"
                    style="background: var(--red);">
                <i class="fas fa-search"></i> 검색
            </button>
        </form>

        <!-- 공지사항 게시판 -->
        <div class="card flex-1 flex flex-col">
            <!-- 게시판 헤더 -->
            <div class="flex items-center justify-between mb-4">
                <h3 class="text-xl font-semibold flex items-center gap-2">
                    <i class="fas fa-bullhorn text-red-500"></i>
                    Notice Board
                </h3>
                <span class="text-gray-400 text-sm">Total : ${noticeCount}</span>
            </div>

            <!-- 게시판 테이블 -->
            <div class="overflow-x-auto flex-1">
                <table class="w-full text-center">
                    <thead>
                        <tr class="border-b border-gray-700 text-gray-400">
                            <th class="py-4 w-1/5">번호</th>
                            <th class="w-1/5">제목</th>
                            <th class="w-1/5">작성자</th>
                            <th class="w-1/5">작성일</th>
                            <th class="w-1/5">조회수</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="notice" items="${noticeList}" varStatus="status">
                            <tr class="border-b border-gray-700 hover:bg-gray-900 transition">
                                <td class="py-4 text-red-500">
                                    ${(page - 1) * pageSize + status.count}
                                </td>
                                <td>
                                    <a href="<%=request.getContextPath()%>/notice?t_gubun=view&notice_id=${notice.noticeId}"
                                       class="hover:text-red-400 transition">
                                        ${notice.title}
                                    </a>
                                </td>
                                <td>${notice.writerName}</td>
                                <td>
                                    <fmt:formatDate value="${notice.createdAt}" pattern="yyyy-MM-dd"/>
                                </td>
                                <td>${notice.viewCount}</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- 하단 영역 -->
        <div class="relative flex items-center justify-end">
            <div class="absolute left-1/2 -translate-x-1/2 flex gap-2">
                <!-- 이전 -->
                <c:if test="${page > 1}">
                    <a href="${pageContext.request.contextPath}/notice?t_gubun=notice&page=${page - 1}&searchType=${searchType}&keyword=${keyword}"
                       class="page-btn w-11 h-11 flex items-center justify-center rounded-xl">
                        <i class="fas fa-angle-left"></i>
                    </a>
                </c:if>

                <!-- 페이지 번호 -->
                <c:forEach var="i" begin="1" end="${totalPages}">
                    <a href="${pageContext.request.contextPath}/notice?t_gubun=notice&page=${i}&searchType=${searchType}&keyword=${keyword}"
                       class="page-btn w-11 h-11 flex items-center justify-center rounded-xl ${i == page ? 'active' : ''}">
                        ${i}
                    </a>
                </c:forEach>

                <!-- 다음 -->
                <c:if test="${page < totalPages}">
                    <a href="${pageContext.request.contextPath}/notice?t_gubun=notice&page=${page + 1}&searchType=${searchType}&keyword=${keyword}"
                       class="page-btn w-11 h-11 flex items-center justify-center rounded-xl">
                        <i class="fas fa-angle-right"></i>
                    </a>
                </c:if>
            </div>

            <!-- 글쓰기 버튼 -->
<button onclick="location.href='<%=request.getContextPath()%>/notice?t_gubun=write'" 
        class="h-10 w-24 rounded-xl text-white font-semibold text-sm
        ${sessionScope.loginUser.id == 'abc' ? '' : 'invisible'}"
        style="background: var(--red);">

    <i class="fas fa-pen"></i> 글쓰기

</button>
        </div>

        <!-- 푸터 포함 -->
        <%@ include file="footer.jsp" %>
    </div>
</div>
</body>
</html>