package common;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;


public class MariaDBConnection {


    private static final String URL =
            "jdbc:mariadb://192.168.0.25:3306/stressdb";

    private static final String USER =
            "claude";

    private static final String PASSWORD =
            "1234";


    public static Connection getConnection()
            throws Exception {

        Class.forName(
            "org.mariadb.jdbc.Driver"
        );

        return DriverManager.getConnection(
                URL,
                USER,
                PASSWORD
        );

    }



    // ResultSet + PreparedStatement + Connection 종료
    public static void close(
            ResultSet rs,
            PreparedStatement ps,
            Connection con) {


        try {

            if(rs != null)
                rs.close();

        } catch(Exception e) {}



        try {

            if(ps != null)
                ps.close();

        } catch(Exception e) {}



        try {

            if(con != null)
                con.close();

        } catch(Exception e) {}

    }



    // PreparedStatement + Connection 종료
    public static void close(
            PreparedStatement ps,
            Connection con) {


        try {

            if(ps != null)
                ps.close();

        } catch(Exception e) {}



        try {

            if(con != null)
                con.close();

        } catch(Exception e) {}

    }

}