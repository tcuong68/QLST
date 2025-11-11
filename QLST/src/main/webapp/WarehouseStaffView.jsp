<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="org.example.qlst.model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("Login.jsp");
        return;
    }
    String role = user.getRole();
    if (role == null || (!role.equalsIgnoreCase("staff") && !role.equalsIgnoreCase("admin"))) {
        response.sendRedirect("MainScreenView.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <title>Bảng điều khiển Kho - Siêu Thị Điện Máy</title>

    <%-- Xóa link Bootstrap và Font cũ --%>
    <%-- Giữ lại link icon --%>
    <link
            rel="stylesheet"
            href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css"
    />

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

        h1, h2, h3, h5 {
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
            display: flex;
            align-items: center;
            gap: 1rem;
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
            position: relative;
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
            cursor: pointer;
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

        /* === CÁC STYLE MỚI CHO TRANG DASHBOARD === */

        /* Navbar additions */
        .user-badge {
            background-color: #005f73; /* Darker teal */
            padding: 0.4rem 1rem;
            border-radius: 50px;
            font-size: 0.85rem;
            font-weight: 600;
            color: white;
        }
        .btn-logout {
            background: rgba(255, 255, 255, 0.2);
            color: white;
            border: 2px solid rgba(255, 255, 255, 0.3);
            padding: 0.4rem 1rem;
            border-radius: 50px;
            font-size: 0.9rem;
            font-weight: 600;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }
        .btn-logout:hover {
            background: #dc3545; /* Red hover for logout */
            border-color: #dc3545;
            color: white;
        }

        /* Hero Section */
        .hero {
            /* Thay thế gradient tối bằng gradient sáng */
            background: linear-gradient(135deg, #e0f2f1 0%, #ffffff 100%); /* Light teal to white */
            color: #005f73; /* Dark teal text */
            padding: 3rem 0;
            text-align: center;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
            /* Bỏ container bên trong, áp dụng trực tiếp */
            width: 100%;
            margin: 0;
        }
        .hero h1 {
            font-size: 2.5rem;
            font-weight: 800;
            margin-bottom: 0.5rem;
            color: #005f73;
        }
        .hero .lead {
            font-size: 1.1rem;
            opacity: 0.9;
            color: #333;
        }
        .hero-icon {
            width: 80px;
            height: 80px;
            background: #008080; /* Main teal */
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1.5rem;
        }
        .hero-icon i {
            font-size: 2.5rem;
            color: white; /* White icon */
        }

        /* Main Content */
        .main-content {
            flex: 1;
            padding: 3rem 0;
        }
        .section-title {
            font-size: 1.8rem;
            font-weight: 700;
            color: #005f73; /* Dark teal */
            margin-bottom: 2rem;
            text-align: center;
        }
        .section-title i {
            color: #008080; /* Main teal */
            margin-right: 0.5rem;
        }

        /* Function Card */
        .function-card {
            background: white;
            border: none;
            border-radius: 16px;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.08);
            transition: all 0.3s ease;
            height: 100%;
            overflow: hidden;
            display: flex;
            flex-direction: column;
        }
        .function-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 12px 35px rgba(0, 0, 0, 0.12);
        }
        .function-card .card-header-custom {
            /* Thay gradient tối bằng gradient teal */
            background: linear-gradient(135deg, #008080 0%, #005f73 100%); /* Teal gradient */
            color: white;
            padding: 2rem;
            text-align: center;
            border: none;
        }
        .function-icon {
            width: 70px;
            height: 70px;
            background: rgba(255, 255, 255, 0.2); /* Transparent white */
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1rem;
        }
        .function-icon i {
            font-size: 2rem;
            color: white; /* White icon */
        }
        .function-card h5 {
            font-weight: 700;
            margin: 0;
            font-size: 1.3rem;
            color: white; /* Chữ header màu trắng */
        }
        .function-card .card-body {
            padding: 1.5rem;
            display: flex;
            flex-direction: column;
            flex: 1; /* Đảm bảo card body co giãn */
        }
        .function-card p {
            color: #6c757d;
            margin-bottom: 1.5rem;
            line-height: 1.6;
            min-height: 70px;
            flex: 1; /* Đẩy nút xuống dưới */
        }
        .btn-function {
            /* Đồng bộ với class .btn */
            background: #008080;
            border: none;
            color: white;
            padding: 0.7rem 1.5rem;
            border-radius: 50px;
            font-weight: 600;
            transition: all 0.3s;
            width: 100%;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            text-decoration: none;
            font-size: 1rem; /* Đồng bộ font-size */
        }
        .btn-function:hover {
            background: #005f73;
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(0, 128, 128, 0.3);
            color: white;
        }

        /* Cấu trúc row/col (giả lập grid đơn giản) */
        .row {
            display: flex;
            flex-wrap: wrap;
            margin: 0 -15px; /* Tạo gutter */
            justify-content: center;
        }
        .col-md-4 {
            width: 100%; /* Mặc định full width */
            padding: 0 15px; /* Gutter */
            margin-bottom: 30px; /* Khoảng cách mb-4 */
            box-sizing: border-box;
        }
        /* Trên màn hình medium (>=768px) */
        @media (min-width: 768px) {
            .col-md-4 {
                flex: 0 0 33.3333%; /* 3 cột */
                max-width: 33.3333%;
            }
        }

        @media (max-width: 767px) {
            .hero h1 {
                font-size: 2rem;
            }
            .section-title {
                font-size: 1.5rem;
            }
            .main-content {
                padding: 2rem 0;
            }
            /* Đảm bảo container không bị dính sát lề */
            .container {
                width: 95%;
            }
        }
    </style>
</head>
<body>
<nav class="navbar">
    <%-- Container được tích hợp trong navbar --%>
    <a class="navbar-brand" href="WarehouseStaffView.jsp">
        <i class="bi bi-box-seam-fill"></i> Quản Lý Kho DMX
    </a>
    <div class="user-info">
      <span class="user-badge">
        <i class="bi bi-person-badge"></i> <%= role.toUpperCase() %>
      </span>
        <span>
        <i class="bi bi-person-circle"></i>
        <strong>
            <%= user.getName() != null ? user.getName() : user.getUsername() %>
        </strong>
      </span>
        <a href="Login.jsp" class="btn-logout">
            <i class="bi bi-box-arrow-right"></i> Đăng xuất
        </a>
    </div>
</nav>

<section class="hero">
    <%-- Container không cần thiết ở đây vì .hero đã 100% width --%>
    <div class="hero-icon">
        <i class="bi bi-buildings-fill"></i>
    </div>
    <h1>Bảng Điều Khiển Kho</h1>
    <p class="lead">Quản lý hoạt động nhập, xuất và tồn kho hàng hóa.</p>
</section>

<main class="main-content">
    <div class="container">
        <h2 class="section-title">
            <i class="bi bi-grid-3x3-gap"></i>
            Chức Năng Kho
        </h2>

        <div class="row">
            <%-- Cột 1 --%>
            <div class="col-md-4">
                <div class="function-card">
                    <div class="card-header-custom">
                        <div class="function-icon">
                            <i class="bi bi-box-arrow-in-down"></i>
                        </div>
                        <h5>Nhập Hàng Hóa</h5>
                    </div>
                    <div class="card-body">
                        <p>
                            Thực hiện quy trình nhập hàng từ nhà cung cấp vào kho, tạo phiếu nhập mới.
                        </p>
                        <a href="SearchSupplierView.jsp" class="btn-function">
                            <i class="bi bi-box-arrow-in-down"></i> Bắt đầu Nhập Hàng
                        </a>
                    </div>
                </div>
            </div>

            <%-- Thêm các cột/chức năng khác ở đây nếu muốn --%>
            <%--
            <div class="col-md-4">
                <div class="function-card">
                     ...
                </div>
            </div>
            --%>

        </div>
    </div>
</main>

<footer>
    © 2025 - Hệ thống quản lý Siêu thị Điện máy DMX
</footer>

<%-- Xóa JS của Bootstrap --%>
</body>
</html>