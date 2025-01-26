<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Management</title>
    <link rel="icon" type="image/x-icon" href="../assets/a.svg">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="../styles/userStyles.css">
</head>
<body>
<div class="page-container">
    <div class="page-header">
        <div>
            <h2 class="mb-1">User Management</h2>
            <p class="text-muted mb-0">Manage your system users and their roles</p>
        </div>
        <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addUserModal">
            <i class="bi bi-plus-lg me-2"></i>Add New User
        </button>
    </div>

    <div class="stats-container">
        <div class="stat-card">
            <div class="stat-title">Total Users</div>
            <div class="stat-value">${totalUsers}</div>
        </div>
        <div class="stat-card">
            <div class="stat-title">Customer Users</div>
            <div class="stat-value">${customerUsers}</div>
        </div>
        <div class="stat-card">
            <div class="stat-title">Admin Users</div>
            <div class="stat-value">${adminUsers}</div>
        </div>
        <div class="stat-card">
            <div class="stat-title">New This Month</div>
            <div class="stat-value">${newUsers}</div>
        </div>
    </div>

    <div class="modern-card">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div class="search-container">
                <i class="bi bi-search search-icon"></i>
                <input type="text" id="searchInput" class="form-control search-input" placeholder="Search users...">
            </div>
            <div class="d-flex gap-2">
                <select class="form-select" id="roleFilter">
                    <option value="">All Roles</option>
                    <option value="ADMIN">Admin</option>
                    <option value="CUSTOMER">Customer</option>
                </select>
            </div>
        </div>

        <div class="table-responsive">
            <table class="table">
                <thead>
                <tr>
                    <th>User Info</th>
                    <th>Email</th>
                    <th>Role</th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="user" items="${users}">
                    <tr>
                        <td>
                            <div class="d-flex align-items-center gap-3">
                                <div class="avatar">${user.firstName.charAt(0)}</div>
                                <div>
                                    <div class="fw-medium">${user.firstName} ${user.lastName}</div>
                                    <div class="text-muted">@${user.username}</div>
                                </div>
                            </div>
                        </td>
                        <td>${user.email}</td>
                        <td>
                            <span class="badge bg-${user.role == 'ADMIN' ? 'primary' : 'secondary'} bg-opacity-10
                                  text-${user.role == 'ADMIN' ? 'primary' : 'secondary'}">
                                    ${user.role}
                            </span>
                        </td>
                        <td>
                            <div class="d-flex gap-2">
                                <button class="btn btn-icon btn-outline-secondary" onclick="editUser('${user.id}')">
                                    <i class="bi bi-pencil"></i>
                                </button>
                                <form action="${pageContext.request.contextPath}/user/delete" method="post"
                                      style="display:inline;" onsubmit="return confirmDelete()">
                                    <input type="hidden" name="userId" value="${user.id}">
                                    <button type="submit" class="btn btn-icon btn-outline-danger">
                                        <i class="bi bi-trash"></i>
                                    </button>
                                </form>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- Add User Modal -->
<div class="modal fade" id="addUserModal">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/user/add" method="post">
                <div class="modal-header">
                    <h5 class="modal-title">Add New User</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label class="form-label">First Name</label>
                            <input type="text" name="firstName" class="form-control" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Last Name</label>
                            <input type="text" name="lastName" class="form-control" required>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Email</label>
                        <input type="email" name="email" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Username</label>
                        <input type="text" name="username" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Password</label>
                        <input type="password" name="password" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Role</label>
                        <select name="role" class="form-select" required>
                            <option value="CUSTOMER">Customer</option>
                            <option value="ADMIN">Admin</option>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">Add User</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Edit User Modal -->
<div class="modal fade" id="editUserModal">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/user/update" method="post">
                <input type="hidden" name="userId" id="editUserId">
                <div class="modal-header">
                    <h5 class="modal-title">Edit User</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label class="form-label">First Name</label>
                            <input type="text" name="firstName" id="editFirstName" class="form-control" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Last Name</label>
                            <input type="text" name="lastName" id="editLastName" class="form-control" required>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Email</label>
                        <input type="email" name="email" id="editEmail" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Username</label>
                        <input type="text" name="username" id="editUsername" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Password</label>
                        <input type="password" name="password" class="form-control" placeholder="Leave blank to keep current password">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Role</label>
                        <select name="role" id="editRole" class="form-select" required>
                            <option value="CUSTOMER">Customer</option>
                            <option value="ADMIN">Admin</option>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">Update User</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    function editUser(userId) {
        $.ajax({
            url: '${pageContext.request.contextPath}/user/get?id=' + userId,
            method: 'GET',
            success: function(user) {
                $('#editUserId').val(user.id);
                $('#editFirstName').val(user.firstName);
                $('#editLastName').val(user.lastName);
                $('#editEmail').val(user.email);
                $('#editUsername').val(user.username);
                $('#editRole').val(user.role);
                $('#editUserModal').modal('show');
            }
        });
    }

    function confirmDelete() {
        return confirm('Are you sure you want to delete this user?');
    }

    $(document).ready(function() {
        // Search functionality
        $('#searchInput').on('keyup', function() {
            var value = $(this).val().toLowerCase();
            $('table tbody tr').filter(function() {
                $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
            });
        });

        // Role filter
        $('#roleFilter').on('change', function() {
            var value = $(this).val().toLowerCase();
            if(value === '') {
                $('table tbody tr').show();
            } else {
                $('table tbody tr').filter(function() {
                    $(this).toggle($(this).find('td:eq(2)').text().toLowerCase().trim() === value)
                });
            }
        });
    });
</script>
</body>
</html>