package lk.ijse.servlets;

import com.google.gson.JsonObject;
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
import java.io.PrintWriter;
import java.time.LocalDateTime;
import java.util.ArrayList;

@WebServlet(name = "RegisterServlet", urlPatterns = "/register")
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Session session = FactoryConfiguration.getInstance().getSession();
        Transaction transaction = null;

        // Set response type to JSON
        resp.setContentType("application/json");
        PrintWriter out = resp.getWriter();
        JsonObject jsonResponse = new JsonObject();

        try {
            // Get form data
            String firstName = req.getParameter("firstName");
            String lastName = req.getParameter("lastName");
            String email = req.getParameter("email");
            String username = req.getParameter("username");
            String password = req.getParameter("password");
            String confirmPassword = req.getParameter("confirmPassword");

            // Basic validation
            if (password == null || !password.equals(confirmPassword)) {
                jsonResponse.addProperty("status", "error");
                jsonResponse.addProperty("message", "Passwords do not match!");
                out.print(jsonResponse.toString());
                return;
            }

            // Check if user exists
            Long existingUser = (Long) session.createQuery(
                            "SELECT COUNT(u) FROM User u WHERE u.username = :username OR u.email = :email")
                    .setParameter("username", username)
                    .setParameter("email", email)
                    .uniqueResult();

            if (existingUser > 0) {
                jsonResponse.addProperty("status", "error");
                jsonResponse.addProperty("message", "Username or email already exists!");
                out.print(jsonResponse.toString());
                return;
            }

            // Create new user
            User user = new User();
            user.setFirstName(firstName);
            user.setLastName(lastName);
            user.setUsername(username);
            user.setPassword(PasswordEncoder.encode(password));
            user.setEmail(email);
            user.setRole("CUSTOMER");
            user.setCreatedAt(LocalDateTime.now());
            user.setOrders(new ArrayList<>());
            user.setCartItems(new ArrayList<>());

            // Save user
            transaction = session.beginTransaction();
            session.save(user);
            transaction.commit();

            // Send success response
            jsonResponse.addProperty("status", "success");
            jsonResponse.addProperty("message", "Registration successful!");
            out.print(jsonResponse.toString());

        } catch (Exception e) {
            if (transaction != null && transaction.isActive()) {
                transaction.rollback();
            }

            // Send error response
            jsonResponse.addProperty("status", "error");
            jsonResponse.addProperty("message", "Registration failed: " + e.getMessage());
            out.print(jsonResponse.toString());

        } finally {
            if (session != null) {
                session.close();
            }
        }
    }
}