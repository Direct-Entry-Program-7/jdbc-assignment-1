package lk.ijse.jdbc_assignment1.model;

import java.io.Serializable;

public class Provider implements Serializable {
    private int id;
    private String name;
    private int contactsCount;
    private int studentsCount;

    public Provider() {
    }

    public Provider(int id, String name, int contactsCount, int studentsCount) {
        this.id = id;
        this.name = name;
        this.contactsCount = contactsCount;
        this.studentsCount = studentsCount;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    @Override
    public String toString() {
        return this.getName();
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getContactsCount() {
        return contactsCount;
    }

    public void setContactsCount(int contactsCount) {
        this.contactsCount = contactsCount;
    }

    public int getStudentsCount() {
        return studentsCount;
    }

    public void setStudentsCount(int studentsCount) {
        this.studentsCount = studentsCount;
    }
}
