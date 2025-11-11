<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="org.example.qlst.model.User" %>
<%@ page import="org.example.qlst.model.Supplier" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
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

    List<Supplier> suppliers = (List<Supplier>) request.getAttribute("suppliers");
    boolean hasSearched = request.getParameter("action") != null || request.getAttribute("suppliers") != null;
    if (suppliers == null) {
        suppliers = new ArrayList<>();
    }
    Supplier newSupplier = (Supplier) request.getAttribute("newSupplier");
    String error = (String) request.getAttribute("error");
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <title>Tìm nhà cung cấp - Siêu Thị Điện Máy DMX</title>

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
            position: relative; /* Thêm cho icon */
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
    </style>

    <%-- Giữ lại link icon --%>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css"/>

</head>
<body>

<nav class="navbar">
    <a class="navbar-brand" href="WarehouseStaffView.jsp">
        <i class="bi bi-box-seam-fill"></i> Quản Lý Kho DMX
    </a>
    <div class="navbar-nav">
        <a href="WarehouseStaffView.jsp" class="btn btn-secondary" style="color:white; text-decoration: none;">
            <i class="bi bi-house-door-fill"></i> Trang chủ
        </a>
    </div>
    <div class="user-info">
        <i class="bi bi-person-circle"></i>
        Xin chào,
        <strong><%= user.getName() != null ? user.getName() : user.getUsername() %></strong>
    </div>
</nav>

<div class="container">
    <h3 style="text-align: center; margin-bottom: 20px;">
        <i class="bi bi-truck"></i> Chọn Nhà Cung Cấp
    </h3>

    <% if (error != null) { %>
    <div class="alert alert-danger">
        <i class="bi bi-exclamation-triangle-fill"></i> <%= error %>
    </div>
    <% } %>

    <% if (newSupplier != null) { %>
    <div class="alert alert-success">
        <i class="bi bi-check-circle-fill"></i> Thêm nhà cung cấp <strong>"<%= newSupplier.getName() %>"</strong> thành công!
    </div>
    <% } %>

    <div class="card">
        <form method="get" action="supplier" id="searchForm">
            <input type="hidden" name="action" value="search"/>
            <div class="input-group">
                 <span style="position: absolute; left: 15px; top: 13px; z-index: 10; color: #6c757d;">
                     <i class="bi bi-search"></i>
                 </span>
                <input type="text" name="q" id="searchInput"
                       placeholder="Tìm kiếm theo tên, số điện thoại hoặc email..."
                       value="<%= request.getParameter("q") != null ? request.getParameter("q") : "" %>"
                       style="padding-left: 40px;"/>
                <button type="submit" class="btn" style="border-radius: 0;">
                    <i class="bi bi-search"></i> Tìm kiếm
                </button>
                <a href="AddSupplierView.jsp" class="btn btn-success"
                   style="text-decoration: none; border-radius: 0 5px 5px 0;">
                    <i class="bi bi-plus-circle-fill"></i> Thêm mới
                </a>
            </div>
        </form>
    </div>

    <div id="supplierList" style="margin-top: 20px;">
        <% if (!hasSearched) { %>
        <div class="card" style="text-align: center; color: #6c757d;">
            <i class="bi bi-search" style="font-size: 3rem;"></i>
            <h5 class="mt-3">Nhập từ khóa và nhấn "Tìm kiếm"</h5>
            <p class="text-secondary"><small>Hoặc nhấn <strong>"Thêm mới"</strong> để tạo nhà cung cấp mới</small></p>
        </div>
        <% } else if (suppliers.isEmpty()) { %>
        <div class="card" style="text-align: center; color: #6c757d;">
            <i class="bi bi-inbox" style="font-size: 3rem;"></i>
            <h5 class="mt-3">Không tìm thấy nhà cung cấp</h5>
            <p>Không có kết quả nào phù hợp với từ khóa
                "<strong><%= request.getParameter("q") != null ? request.getParameter("q") : "" %></strong>"</p>
            <p class="text-secondary"><small>Thử tìm kiếm với từ khóa khác hoặc nhấn <strong>"Thêm mới"</strong></small>
            </p>
        </div>
        <% } else { %>
        <div style="margin-bottom: 15px;">
            <h6 style="color: #555;">
                <i class="bi bi-check-circle-fill" style="color: #28a745;"></i>
                Tìm thấy <strong><%= suppliers.size() %></strong> nhà cung cấp
                <% if (request.getParameter("q") != null && !request.getParameter("q").isEmpty()) { %>
                cho từ khóa "<strong><%= request.getParameter("q") %></strong>"
                <% } %>
            </h6>
        </div>

        <div class="table-container">
            <table>
                <thead>
                <tr>
                    <th style="width: 5%;">STT</th>
                    <th style="width: 30%;">Tên nhà cung cấp</th>
                    <th style="width: 15%;">Số điện thoại</th>
                    <th style="width: 20%;">Email</th>
                    <th style="width: 25%;">Địa chỉ</th>
                    <th style="width: 5%; text-align: center;">Chọn</th>
                </tr>
                </thead>
                <tbody>
                <%
                    int stt = 1;
                    for (Supplier supplier : suppliers) {
                %>
                <tr onclick="selectSupplier(this)"
                    data-id="<%= supplier.getId() %>"
                    data-name="<%= supplier.getName() %>"
                    data-phone="<%= supplier.getPhone() != null ? supplier.getPhone() : "" %>"
                    data-email="<%= supplier.getEmail() != null ? supplier.getEmail() : "" %>"
                    data-address="<%= supplier.getAddress() != null ? supplier.getAddress() : "" %>">
                    <td style="text-align: center;"><%= stt++ %></td>
                    <td><strong><%= supplier.getName() %></strong></td>
                    <td>
                        <i class="bi bi-telephone-fill" style="color: #007bff;"></i>
                        <%= supplier.getPhone() != null ? supplier.getPhone() : "Chưa có" %>
                    </td>
                    <td>
                        <i class="bi bi-envelope-fill" style="color: #17a2b8;"></i>
                        <%= supplier.getEmail() != null ? supplier.getEmail() : "Chưa có" %>
                    </td>
                    <td>
                        <i class="bi bi-geo-alt-fill" style="color: #dc3545;"></i>
                        <%= supplier.getAddress() != null && !supplier.getAddress().isEmpty() ? supplier.getAddress() : "Chưa có" %>
                    </td>
                    <td style="text-align: center;">
                        <input type="radio" name="selectedSupplier" class="supplier-radio"/>
                    </td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
        <% } %>
    </div>
</div>

<button class="btn-floating" id="btnContinue" onclick="continueToImport()" disabled>
    Tiếp tục <i class="bi bi-arrow-right-circle-fill"></i>
</button>

<footer>
    <p>© 2025 - Hệ thống quản lý Siêu thị Điện máy DMX</p>
</footer>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<script>
    let selectedSupplierData = null;

    function selectSupplier(row) {
        // Bỏ 'selected' class khỏi tất cả các hàng
        $('table tbody tr').removeClass('selected');
        // Thêm 'selected' class cho hàng được click
        $(row).addClass('selected');

        // Check radio button tương ứng
        $(row).find('.supplier-radio').prop('checked', true);

        selectedSupplierData = {
            id: $(row).data('id'),
            name: $(row).data('name'),
            phone: $(row).data('phone'),
            email: $(row).data('email'),
            address: $(row).data('address')
        };

        $('#btnContinue').prop('disabled', false);
    }

    // Xử lý khi click trực tiếp vào radio
    $(document).on('click', '.supplier-radio', function (e) {
        e.stopPropagation(); // Ngăn event lan ra row
        const row = $(this).closest('tr');
        selectSupplier(row);
    });

    function continueToImport() {
        if (!selectedSupplierData) {
            alert('Vui lòng chọn nhà cung cấp!');
            return;
        }

        // Xóa các lựa chọn sản phẩm cũ nếu chọn NCC mới
        sessionStorage.removeItem('selectedProducts');

        sessionStorage.setItem('selectedSupplier', JSON.stringify(selectedSupplierData));
        sessionStorage.setItem('selectedSupplierId', selectedSupplierData.id);

        const qs = new URLSearchParams({
            supplierId: selectedSupplierData.id,
            supplierName: selectedSupplierData.name
        });
        window.location.href = 'SearchProductView.jsp?' + qs.toString();
    }
</script>
</body>
</html>