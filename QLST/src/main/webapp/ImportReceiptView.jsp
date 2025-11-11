<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, org.example.qlst.model.ImportReceiptDetail, org.example.qlst.model.User" %>
<%
    @SuppressWarnings("unchecked")
    List<ImportReceiptDetail> items = (List<ImportReceiptDetail>) session.getAttribute("pendingImportItems");

    @SuppressWarnings("unchecked")
    Map<Integer, String> names = (Map<Integer, String>) session.getAttribute("pendingImportNames");
    String supplierName = (String) session.getAttribute("selectedSupplierName");
    Integer lastSavedImportReceiptId = (Integer) session.getAttribute("lastSavedImportReceiptId");
    User user = (User) session.getAttribute("user");

    // Đảm bảo user không null khi hiển thị navbar
    if (user == null) {
        response.sendRedirect("Login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <title>Xác nhận Nhập Hàng - DMX</title>

    <%-- Xóa link Bootstrap và Font Awesome --%>
    <%-- Thêm link Bootstrap Icons --%>
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
            min-height: 100vh;
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
            background-color: #005f73;
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
            line-height: 1.5;
        }

        .btn:hover {
            background-color: #005f73; /* Xanh đậm hơn */
        }

        .btn:disabled {
            background-color: #aaa;
            cursor: not-allowed;
            opacity: 0.7;
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

        /* Trạng thái thẻ đã lưu */
        .card-success {
            background-color: #d4edda;
            border: 1px solid #c3e6cb;
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
            background-color: #eef;
        }

        /* --- Alerts (Thông báo) --- */
        .alert {
            padding: 15px;
            margin-bottom: 20px;
            border: 1px solid transparent;
            border-radius: 4px;
            display: flex;
            align-items: center;
            gap: 10px;
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

        .alert-info {
            color: #0c5460;
            background-color: #d1ecf1;
            border-color: #bee5eb;
        }

        /* --- Style từ trang Dashboard (Navbar) --- */
        .user-badge {
            background-color: #005f73;
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
            background: #dc3545;
            border-color: #dc3545;
            color: white;
        }

        /* --- Lớp tiện ích (Utility Classes) --- */
        .text-right { text-align: right; }
        .text-center { text-align: center; }
        .font-weight-bold { font-weight: bold; }
        .d-flex { display: flex; }
        .justify-content-between { justify-content: space-between; }
        .mt-3 { margin-top: 20px; }
        .text-success { color: #155724; }

    </style>
</head>
<body> <%-- Bỏ class bg-light --%>

<nav class="navbar">
    <a class="navbar-brand" href="WarehouseStaffView.jsp">
        <i class="bi bi-box-seam-fill"></i> Quản Lý Kho DMX
    </a>
    <div class="user-info">
      <span class="user-badge">
        <i class="bi bi-person-badge"></i> <%= user.getRole().toUpperCase() %>
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

<div class="container">
    <h2 class="text-center" style="margin-bottom: 20px;">Xác nhận Phiếu Nhập Hàng</h2>

    <% if (request.getAttribute("error") != null) { %>
    <div class="alert alert-danger">
        <i class="bi bi-exclamation-triangle-fill"></i>
        <%= request.getAttribute("error") %>
    </div>
    <% } %>

    <% if (request.getAttribute("success") != null) { %>
    <div class="alert alert-success">
        <i class="bi bi-check-circle-fill"></i>
        <%= request.getAttribute("success") %>
    </div>
    <% } %>

    <% if (lastSavedImportReceiptId != null) { %>
    <div class="alert alert-info">
        <i class="bi bi-info-circle-fill"></i>
        <div> <%-- Thêm div để xuống dòng --%>
            <strong>Phiếu đã được lưu thành công!</strong>
            Mã phiếu nhập: <strong>#<%= lastSavedImportReceiptId %></strong>
            <br><small>Danh sách <strong>sản phẩm</strong> bên dưới đã được ghi nhận vào hệ thống và tồn kho đã được cập nhật.</small>
        </div>
    </div>
    <%
        session.removeAttribute("lastSavedImportReceiptId");
    %>
    <% } %>

    <%-- Dùng class .card đồng nhất --%>
    <div class="card">
        <p>
            <strong>Nhà cung cấp:</strong>
            <%= supplierName != null ? supplierName : "(chưa chọn)" %>
        </p>
        <p style="margin-bottom: 0;">
            <strong>Nhân viên:</strong>
            <%= (user.getName() != null) ?
                    user.getName() : "(không xác định)" %>
        </p>
    </div>


    <%-- Dùng .table-container và class .card-success (nếu đã lưu) --%>
    <div class="table-container <%= lastSavedImportReceiptId != null ? "card-success" : "" %>">
        <table>
            <thead> <%-- Bỏ class thead-dark --%>
            <tr>
                <th style="width: 8%">STT</th>
                <th>Tên sản phẩm</th>
                <th class="text-right">Giá nhập</th>
                <th class="text-center">Số lượng</th>
                <th class="text-right">Thành tiền</th>
            </tr>
            </thead>
            <tbody>
            <% int stt = 1; long total = 0; if (items != null) {
                for (ImportReceiptDetail it : items) {
                    long sub =
                            Math.round(it.getPrice() * it.getQuantity()); total +=
                            sub; %>
            <tr>
                <td class="text-center"><%= stt++ %></td>
                <td>
                    <strong>
                        <%= names != null
                                ? names.getOrDefault(it.getProductId(), "Không xác định")
                                : "Không xác định" %>
                    </strong>
                </td>
                <td class="text-right">
                    <%= String.format("%,d", (long) it.getPrice()) %>
                </td>
                <td class="text-center"><%= it.getQuantity() %></td>
                <td class="text-right">
                    <%= String.format("%,d", sub) %>
                </td>
            </tr>
            <% } } %>
            </tbody>
            <tfoot>
            <tr style="background: #f4f7f6;">
                <td colspan="4" class="text-right font-weight-bold">
                    Tổng
                </td>
                <td class="text-right font-weight-bold">
                    <%= String.format("%,d", total) %>
                </td>
            </tr>
            </tfoot>
        </table>
    </div>

    <%-- Dùng các class tiện ích đã thêm vào CSS --%>
    <div class="d-flex justify-content-between mt-3">
        <a href="product?action=search" class="btn btn-secondary"
        >Quay lại (Tìm sản phẩm)</a>

        <% if (lastSavedImportReceiptId == null) { %>
        <form method="post" action="importReceipt" style="margin-bottom: 0;">
            <input type="hidden" name="action" value="save" />
            <button type="submit" class="btn" <%= (items == null || items.isEmpty()) ? "disabled" : "" %>>
                <i class="bi bi-check-circle-fill"></i> Xác nhận lưu phiếu
            </button>
        </form>
        <% } else { %>
        <div>
              <span class="text-success font-weight-bold" style="font-size: 1.1rem; display: flex; align-items: center; gap: 8px;">
                <i class="bi bi-check-circle-fill"></i> Phiếu nhập đã được lưu
              </span>
        </div>
        <% } %>
    </div>
</div>

<%-- Thêm footer đồng nhất --%>
<footer>
    <p>© 2025 - Hệ thống quản lý Siêu thị Điện máy DMX</p>
</footer>

<%-- Xóa các link script của Bootstrap và jQuery --%>
</body>
</html>