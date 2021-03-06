package lk.ijse.jdbc_assignment1.controller;

import javafx.beans.property.ReadOnlyObjectWrapper;
import javafx.event.ActionEvent;
import javafx.scene.control.*;
import javafx.scene.control.cell.PropertyValueFactory;
import lk.ijse.jdbc_assignment1.model.Provider;
import lk.ijse.jdbc_assignment1.util.DBConnection;

import java.io.IOException;
import java.sql.*;

public class ManageProvidersFormController {
    public TextField txtID;
    public TextField txtProvider;
    public Button btnSave;
    public TableView<Provider> tblProviders;
    private Connection connection;
    private PreparedStatement pstmSaveProvider;
    private PreparedStatement pstmDeleteProvider;

    public void initialize(){
        tblProviders.getColumns().get(0).setCellValueFactory(new PropertyValueFactory<>("id"));
        tblProviders.getColumns().get(1).setCellValueFactory(new PropertyValueFactory<>("name"));
        tblProviders.getColumns().get(2).setCellValueFactory(new PropertyValueFactory<>("contactsCount"));
        tblProviders.getColumns().get(3).setCellValueFactory(new PropertyValueFactory<>("studentsCount"));
        TableColumn<Provider, Button> colDelete = (TableColumn<Provider, Button>) tblProviders.getColumns().get(4);

        txtProvider.setOnAction(this::btnSave_OnAction);

        colDelete.setCellValueFactory(param -> {
            Button btnDelete = new Button("Remove");

            btnDelete.setOnAction(event -> {

                try {
                    pstmDeleteProvider.setInt(1, param.getValue().getId());
                    if (pstmDeleteProvider.executeUpdate() == 1){
                        new Alert(Alert.AlertType.INFORMATION, param.getValue().getId() + " has been deleted successfully").show();
                        tblProviders.getItems().remove(param.getValue());
                    }else{
                        throw new RuntimeException("Failed to delete the provider");
                    }
                } catch (SQLException | RuntimeException e) {
                    e.printStackTrace();
                    new Alert(Alert.AlertType.ERROR, e.getMessage()).show();
                }

            });
            return new ReadOnlyObjectWrapper<>(btnDelete);
        });

        try {
            connection = DBConnection.getInstance().getConnection();
            pstmSaveProvider = connection.prepareStatement("INSERT INTO provider (id,provider) VALUES (?,?)");
            pstmDeleteProvider = connection.prepareStatement("DELETE FROM provider WHERE id=?");
        } catch (SQLException e) {
            e.printStackTrace();
        }

        loadAllProviders();
    }

    private void loadAllProviders(){

        tblProviders.getItems().clear();

        try {
            Statement stm = connection.createStatement();
            ResultSet rst = stm.executeQuery("SELECT id, provider, COUNT(contact) as contacts, COUNT(DISTINCT student_id) as students\n" +
                    "FROM contact RIGHT OUTER JOIN provider p on contact.provider_id = p.id GROUP BY provider ORDER BY contacts DESC;");

            while (rst.next()){
                tblProviders.getItems().add(new Provider(rst.getInt("id"),
                        rst.getString("provider"),
                        rst.getInt("contacts"),
                        rst.getInt("students")));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void btnBack_OnAction(ActionEvent actionEvent) throws IOException {
        HomeFormController.navigate(HomeFormController.NavigationMenu.HOME);
    }

    public void btnSave_OnAction(ActionEvent actionEvent) {

        String provider = txtProvider.getText();

        if (txtID.getText().trim().isEmpty() || provider.trim().isEmpty() || !txtID.getText().matches("\\d+")){
            new Alert(Alert.AlertType.ERROR, "Please enter valid details").show();
            return;
        }

        try {
            pstmSaveProvider.setInt(1, Integer.parseInt(txtID.getText()));
            pstmSaveProvider.setString(2, provider);
            if (pstmSaveProvider.executeUpdate() == 1){
                new Alert(Alert.AlertType.INFORMATION, "Provider has been saved successfully").show();
                tblProviders.getItems().add(new Provider(Integer.parseInt(txtID.getText()), provider, 0,0));
                txtID.clear();
                txtProvider.clear();
                txtID.requestFocus();
            }else{
                throw new RuntimeException("Failed to save the provider");
            }

        } catch (SQLException|RuntimeException e) {
            e.printStackTrace();
            new Alert(Alert.AlertType.ERROR, e.getMessage()).show();
        }

    }
}
