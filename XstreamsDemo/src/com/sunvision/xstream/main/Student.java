package com.sunvision.xstream.main;

import java.util.ArrayList;

public class Student {
	private String name;
	private ArrayList<Note> notes = new ArrayList<Note>();

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public ArrayList<Note> getNotes() {
		return notes;
	}

	public void setNotes(ArrayList<Note> notes) {
		this.notes = notes;
	}

	public void addNote(Note note) {
		notes.add(note);
	}
}
