<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Stress Lab - Dashboard</title>

    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="css/styles.css">
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>

<body>
    <div class="flex h-screen">
        <%@ include file="sidebar.jsp" %>

        <div class="flex-1 flex flex-col p-8 overflow-auto space-y-4">
            <!-- Title -->
            <div>
                <h2 class="text-4xl font-bold">Vulnerability Dashboard</h2>
                <p class="text-gray-400 mt-2">실시간 취약점 수집 및 분석 현황</p>
            </div>

            <!-- =====================
                 STATUS CARD
            ===================== -->
            <div class="grid grid-cols-1 md:grid-cols-3 gap-5">
                <div class="card">
                    <p class="text-gray-400">Critical Vulnerability</p>
                    <p class="text-4xl font-bold text-red-500 mt-2">120</p>
                    <span class="text-sm text-gray-400">심각도 Critical</span>
                </div>

                <div class="card">
                    <p class="text-gray-400">High Vulnerability</p>
                    <p class="text-4xl font-bold text-orange-400 mt-2">350</p>
                    <span class="text-sm text-gray-400">높은 위험도</span>
                </div>

                <div class="card">
                    <p class="text-gray-400">Total CVE</p>
                    <p class="text-4xl font-bold mt-2">1,250</p>
                    <span class="text-sm text-gray-400">전체 취약점</span>
                </div>
            </div>

            <!-- =====================
                 CHART
            ===================== -->
            <div class="card">
                <div class="flex justify-between items-center mb-3">
                    <h3 class="text-xl font-semibold">
                        <i class="fa-solid fa-chart-line text-red-500"></i>
                        CVE 발생 추이
                    </h3>
                    <span id="status" class="connected">● 정상</span>
                </div>

                <div style="height:280px">
                    <canvas id="cveChart"></canvas>
                </div>
            </div>

            <!-- =====================
                 LIST AREA
            ===================== -->
            <div class="grid grid-cols-1 lg:grid-cols-2 gap-5">
                <!-- 최근 취약점 -->
                <div class="card">
                    <h3 class="text-xl font-semibold mb-4">
                        <i class="fa-solid fa-bug text-red-500"></i>
                        최근 발견 취약점
                    </h3>

                    <table class="dashboard-table">
                        <thead>
                            <tr>
                                <th>CVE</th>
                                <th>제품</th>
                                <th>위험도</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>CVE-2026-0001</td>
                                <td>Apache Tomcat</td>
                                <td class="!text-red-400">CRITICAL</td>
                            </tr>
                            <tr>
                                <td>CVE-2026-0002</td>
                                <td>OpenSSL</td>
                                <td class="!text-orange-400">HIGH</td>
                            </tr>
                            <tr>
                                <td>CVE-2026-0003</td>
                                <td>Linux Kernel</td>
                                <td class="!text-yellow-400">MEDIUM</td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <!-- 위험 제품 -->
                <div class="card">
                    <h3 class="text-xl font-semibold mb-4">
                        <i class="fa-solid fa-triangle-exclamation text-red-500"></i>
                        위험 제품 TOP
                    </h3>

                    <div class="space-y-4">
                        <div>
                            <div class="flex justify-between">
                                <span>Apache</span>
                                <span class="text-red-400">120</span>
                            </div>
                            <div class="bg-gray-700 h-2 rounded mt-2">
                                <div class="bg-red-500 h-2 rounded" style="width:85%"></div>
                            </div>
                        </div>

                        <div>
                            <div class="flex justify-between">
                                <span>OpenSSL</span>
                                <span class="text-orange-400">90</span>
                            </div>
                            <div class="bg-gray-700 h-2 rounded mt-2">
                                <div class="bg-orange-400 h-2 rounded" style="width:65%"></div>
                            </div>
                        </div>

                        <div>
                            <div class="flex justify-between">
                                <span>Linux Kernel</span>
                                <span>70</span>
                            </div>
                            <div class="bg-gray-700 h-2 rounded mt-2">
                                <div class="bg-yellow-400 h-2 rounded" style="width:50%"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Footer -->
            <div class="pt-4">
                <%@ include file="footer.jsp" %>
            </div>
        </div>
    </div>

    <script>
        const ctx = document.getElementById('cveChart');
        new Chart(ctx, {
            type: 'line',
            data: {
                labels: ['1월', '2월', '3월', '4월', '5월', '6월'],
                datasets: [{
                    label: 'CVE 발생',
                    data: [120, 180, 150, 250, 320, 400],
                    borderColor: '#ef4444',
                    backgroundColor: 'rgba(239,68,68,0.2)',
                    fill: true,
                    tension: 0.4
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        labels: { color: '#f3f4f6' }
                    }
                },
                scales: {
                    x: { ticks: { color: '#9ca3af' } },
                    y: { ticks: { color: '#9ca3af' } }
                }
            }
        });
    </script>
</body>
</html>