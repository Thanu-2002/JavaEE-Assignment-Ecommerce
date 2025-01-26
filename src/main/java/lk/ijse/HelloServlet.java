package lk.ijse;

import java.io.*;

import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import lk.ijse.config.FactoryConfiguration;
import org.hibernate.Session;
import org.hibernate.query.Query;

@WebServlet(urlPatterns = "/hello")
public class HelloServlet extends HttpServlet {

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        System.out.println("Hello from GET method");

        Session session = FactoryConfiguration.getInstance().getSession();
        session.beginTransaction();
        Query query = session.createQuery("FROM User");
        System.out.println(query.list());
        session.getTransaction().commit();
        response.getWriter().write(query.list().toString());
        session.close();

    }
}