<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Trang Chủ - Hệ Thống Quản Lý Siêu Thị</title>

    <%-- CSS MỚI ĐƯỢC NHÚNG TRỰC TIẾP --%>
    <style>
        /* === CSS NHÚNG TRONG === */

        /* --- Cài đặt chung & Font --- */
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f7f6; /* Màu nền xám rất nhạt */
            color: #333;
            margin: 0;
            padding: 0;
            display: flex;
            flex-direction: column;
            min-height: 100vh; /* Đảm bảo footer luôn ở cuối trang */
        }

        .container {
            width: 90%;
            max-width: 1200px;
            margin: 20px auto;
            flex: 1; /* Đẩy footer xuống dưới */
        }

        h1, h2, h3 {
            color: #005f73; /* Màu xanh đậm cho tiêu đề */
        }

        /* --- Header / Navbar (Thanh điều hướng) --- */
        .navbar {
            background-color: #008080; /* Màu xanh mòng két (Teal) */
            color: white;
            padding: 1rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }

        .navbar-brand {
            font-size: 1.5rem;
            font-weight: bold;
            color: white;
            text-decoration: none;
        }

        .navbar-nav a {
            color: white;
            text-decoration: none;
            margin: 0 10px;
            font-weight: bold;
            padding: 5px 10px;
            border-radius: 4px;
            transition: background-color 0.3s;
        }

        .navbar-nav a:hover {
            background-color: #005f73; /* Màu xanh đậm hơn khi hover */
        }

        .user-info {
            color: white;
        }

        /* --- Footer (Chân trang) --- */
        footer {
            background-color: #333;
            color: #eee;
            text-align: center;
            padding: 1.5rem;
            margin-top: auto; /* Dính xuống đáy */
        }

        /* --- Buttons (Nút bấm) --- */
        .btn {
            background-color: #008080; /* Màu xanh mòng két */
            color: white;
            border: none;
            padding: 12px 20px;
            font-size: 16px;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            transition: background-color 0.3s;
            line-height: 1.5; /* Căn chỉnh text */
        }

        .btn:hover {
            background-color: #005f73; /* Xanh đậm hơn */
        }

        /* Các biến thể màu nút */
        .btn-success {
            background-color: #28a745;
        }
        .btn-success:hover {
            background-color: #218838;
        }

        .btn-danger {
            background-color: #dc3545;
        }
        .btn-danger:hover {
            background-color: #c82333;
        }

        .btn-secondary {
            background-color: #6c757d;
        }
        .btn-secondary:hover {
            background-color: #5a6268;
        }

        /* --- Forms & Cards (Biểu mẫu & Thẻ) --- */
        .card {
            background: white;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
        }

        .input-group {
            display: flex;
            width: 100%;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            border-radius: 5px;
        }

        .input-group input[type="text"] {
            flex: 1;
            padding: 12px 15px;
            font-size: 1rem;
            border: 1px solid #ccc;
            border-radius: 5px 0 0 5px;
            outline: none;
            transition: border-color 0.3s;
        }

        .input-group input[type="text"]:focus {
            border-color: #008080;
        }

        .input-group .btn {
            border-radius: 0 5px 5px 0;
            /* Nút sẽ tự động nhận style từ .btn */
        }

        /* --- Tables (Bảng) --- */
        .table-container {
            overflow-x: auto;
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            border: 1px solid #ddd;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 0;
        }

        table thead {
            background-color: #005f73; /* Xanh đậm */
            color: white;
        }

        table th, table td {
            padding: 12px 15px;
            border-bottom: 1px solid #ddd;
            text-align: left;
            vertical-align: middle;
        }

        table tbody tr:nth-child(even) {
            background-color: #f9f9f9;
        }

        table tbody tr:hover {
            background-color: #eef; /* Màu xanh nhạt khi hover */
        }

        table tbody tr.selected {
            background-color: #d6f5f5; /* Màu xanh mòng két rất nhạt */
            border-left: 4px solid #008080;
            font-weight: bold;
        }

        /* --- Input Checkbox/Radio --- */
        input[type="checkbox"], input[type="radio"] {
            width: 18px;
            height: 18px;
            cursor: pointer;
            accent-color: #008080; /* Màu của dấu tick/chọn */
            vertical-align: middle;
        }

        /* --- Alerts (Thông báo) --- */
        .alert {
            padding: 15px;
            margin-bottom: 20px;
            border: 1px solid transparent;
            border-radius: 4px;
            display: flex;
            align-items: center;
            gap: 10px; /* Khoảng cách giữa icon và text */
        }

        .alert-success {
            color: #155724;
            background-color: #d4edda;
            border-color: #c3e6cb;
        }

        .alert-danger {
            color: #721c24;
            background-color: #f8d7da;
            border-color: #f5c6cb;
        }

        /* --- Nút bấm nổi (Floating Button) --- */
        .btn-floating {
            position: fixed;
            bottom: 2rem;
            right: 2rem;
            /* Kế thừa style từ .btn */
            padding: 1rem 2rem;
            font-size: 1.1rem;
            font-weight: 700;
            border-radius: 50px;
            box-shadow: 0 8px 25px rgba(0, 128, 128, 0.3);
            z-index: 1000;
        }

        .btn-floating:disabled {
            background-color: #aaa;
            cursor: not-allowed;
            opacity: 0.7;
        }
    </style>

    <%-- Giữ lại link icon nếu bạn muốn dùng --%>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css"/>
</head>
<body>

<%-- Gộp Header và Nav thành 1 Navbar đồng nhất --%>
<nav class="navbar">
    <a href="#" class="navbar-brand">SIÊU THỊ ĐIỆN MÁY DMX</a>
    <div class="navbar-nav">
        <a href="#">Trang chủ</a>
        <a href="#">Sản phẩm</a>
        <a href="#">Đơn hàng</a>
        <a href="#">Báo cáo</a>
        <a href="#">Liên hệ</a>
    </div>
    <%-- Thêm mục user-info trống nếu cần --%>
    <div class="user-info">
        <%-- (Có thể thêm thông tin user ở đây) --%>
    </div>
</nav>

<div class="container">
    <div class="card" style="text-align: center; margin-top: 50px;">
        <h2>Chào mừng đến siêu thị điện máy DMX</h2>
        <%-- <p>Quản lý hàng hóa, đơn hàng và khách hàng hiệu quả.</p> --%>
        <a href="InforFormView.jsp" class="btn">Đăng ký Membership</a>
    </div>
</div>

<footer>
    <p>© 2025 - Hệ thống quản lý siêu thị điện máy</p>
</footer>
</body>
</html>