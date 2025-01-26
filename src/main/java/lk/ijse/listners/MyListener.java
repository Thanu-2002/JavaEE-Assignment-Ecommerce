package lk.ijse.listners;

import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import lk.ijse.config.FactoryConfiguration;
import org.apache.commons.dbcp2.BasicDataSource;
import org.hibernate.Session;

import java.sql.SQLException;

@WebListener
public class MyListener implements ServletContextListener {
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("Context initialized");
        BasicDataSource basicDataSource = new BasicDataSource();
        basicDataSource.setDriverClassName("com.mysql.cj.jdbc.Driver");
        basicDataSource.setUrl("jdbc:mysql://localhost:3306/ecommerce?createDatabaseIfNotExist=true");
        basicDataSource.setUsername("root");
        basicDataSource.setPassword("Ijse@123");
        basicDataSource.setInitialSize(5);
        basicDataSource.setMaxTotal(10);
        basicDataSource.setMaxIdle(5);
        basicDataSource.setMinIdle(2);
        basicDataSource.setInitialSize(5);

        ServletContext servletContext = sce.getServletContext();
        servletContext.setAttribute("db", basicDataSource);

        // Initialize Hibernate with our connection pool
        FactoryConfiguration.initialize(basicDataSource);

        System.out.println("Database connection established");

        Session session = FactoryConfiguration.getInstance().getSession();
        session.beginTransaction();
        session.getTransaction().commit();
        session.close();
        System.out.println("Hibernate initialized");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        ServletContext servletContext = sce.getServletContext();
        BasicDataSource basicDataSource = (BasicDataSource) servletContext.getAttribute("db");
        try {
            basicDataSource.close();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
}