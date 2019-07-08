package com.example.drift_bottle.entity;

import java.io.Serializable;
import java.sql.Time;

public class ConversationDto implements Serializable {
    private String emid; //环信id
    private int unread; //未读消息数量
    private String lastMessage; //最后一条消息
    private String lastMessageTime;//接收最后一条消息时间

    public void setEmid(String emid) {
        this.emid = emid;
    }

    public void setUnread(int unread) {
        this.unread = unread;
    }

    public void setLastMessage(String lastMessage) {
        this.lastMessage = lastMessage;
    }

    public void setLastMessageTime(String lastMessageTime) {
        this.lastMessageTime = lastMessageTime;
    }

    public String getEmid() {
        return emid;
    }

    public int getUnread() {
        return unread;
    }

    public String getLastMessage() {
        return lastMessage;
    }

    public String getLastMessageTime() {
        return lastMessageTime;
    }
}
