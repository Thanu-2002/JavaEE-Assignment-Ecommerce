package lk.ijse.servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lk.ijse.config.FactoryConfiguration;
import lk.ijse.entity.User;
import lk.ijse.util.PasswordEncoder;
import org.hibernate.Session;
import org.hibernate.Transaction;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;

@WebServlet(urlPatterns = {"/user", "/user/*"})
public class UserServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try (Session session = FactoryConfiguration.getInstance().getSession()) {
            List<User> users = session.createQuery("FROM User", User.class).list();

            Long totalUsers = (Long) session.createQuery("SELECT COUNT(u) FROM User u").uniqueResult();
            Long adminUsers = (Long) session.createQuery("SELECT COUNT(u) FROM User u WHERE u.role = 'ADMIN'").uniqueResult();
            Long customerUsers = (Long) session.createQuery("SELECT COUNT(u) FROM User u WHERE u.role = 'CUSTOMER'").uniqueResult();
            Long newUsers = (Long) session.createQuery(
                            "SELECT COUNT(u) FROM User u WHERE MONTH(u.createdAt) = MONTH(CURRENT_DATE())")
                    .uniqueResult();

            request.setAttribute("users", users);
            request.setAttribute("totalUsers", totalUsers);
            request.setAttribute("adminUsers", adminUsers);
            request.setAttribute("customerUsers", customerUsers);
            request.setAttribute("newUsers", newUsers);

            request.getRequestDispatcher("/view/users.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Session session = null;
        Transaction transaction = null;

        try {
            session = FactoryConfiguration.getInstance().getSession();
            transaction = session.beginTransaction();

            String requestURI = request.getRequestURI();
            String action = requestURI.substring(requestURI.lastIndexOf("/") + 1);

            switch (action) {
                case "add":
                    User user = new User();
                    user.setUsername(request.getParameter("username"));
                    user.setEmail(request.getParameter("email"));
                    user.setPassword(PasswordEncoder.encode(request.getParameter("password")));
                    user.setFirstName(request.getParameter("firstName"));
                    user.setLastName(request.getParameter("lastName"));
                    user.setRole(request.getParameter("role"));
                    user.setCreatedAt(LocalDateTime.now());
                    session.persist(user);
                    break;

                case "update":
                    Long editId = Long.parseLong(request.getParameter("userId"));
                    User existingUser = session.get(User.class, editId);
                    if (existingUser != null) {
                        existingUser.setUsername(request.getParameter("username"));
                        existingUser.setEmail(request.getParameter("email"));
                        existingUser.setFirstName(request.getParameter("firstName"));
                        existingUser.setLastName(request.getParameter("lastName"));
                        existingUser.setRole(request.getParameter("role"));

                        String newPassword = request.getParameter("password");
                        if (newPassword != null && !newPassword.isEmpty()) {
                            existingUser.setPassword(PasswordEncoder.encode(newPassword));
                        }
                        session.merge(existingUser);
                    }
                    break;

                case "delete":
                    Long deleteId = Long.parseLong(request.getParameter("userId"));
                    User userToDelete = session.get(User.class, deleteId);
                    if (userToDelete != null) {
                        session.remove(userToDelete);
                    }
                    break;
            }

            transaction.commit();
            response.sendRedirect(request.getContextPath() + "/user");

        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            throw new ServletException("Error processing request", e);
        } finally {
            if (session != null) {
                session.close();
            }
        }
    }
}