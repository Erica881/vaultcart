"use client";
import { useEffect, useState } from "react";

export default function CustomerDashboard() {
  const [orders, setOrders] = useState([]);

  useEffect(() => {
    async function getOrders() {
      const token = localStorage.getItem("vault_token");
      const res = await fetch("/api/customer/orders", {
        headers: { Authorization: `Bearer ${token}` },
      });
      const data = await res.json();
      setOrders(data);
    }
    getOrders();
  }, []);

  return (
    <div style={{ padding: "20px" }}>
      <h1>🛒 My Shopping Dashboard</h1>
      <h3>My Recent Orders</h3>
      {orders.length === 0 ? (
        <p>No orders found.</p>
      ) : (
        <ul>
          {orders.map((o: any) => (
            <li key={o.OrderID}>
              Order #{o.OrderID} - Total: ${o.TotalAmount}
            </li>
          ))}
        </ul>
      )}
    </div>
  );
}
