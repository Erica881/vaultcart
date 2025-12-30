"use client";
import { useState } from "react";

export default function SellerDashboard() {
  const [product, setProduct] = useState({ name: "", price: "", stock: "" });

  const handleAddProduct = async (e: React.FormEvent) => {
    e.preventDefault();
    const token = localStorage.getItem("vault_token");

    const res = await fetch("/api/seller/add-product", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${token}`,
      },
      body: JSON.stringify(product),
    });

    if (res.ok) {
      alert("Product added to your store!");
      setProduct({ name: "", price: "", stock: "" });
    }
  };

  return (
    <div style={{ padding: "20px" }}>
      <h1>🏪 Seller Management Portal</h1>

      <div
        style={{
          border: "1px solid #ddd",
          padding: "20px",
          borderRadius: "8px",
          maxWidth: "400px",
        }}
      >
        <h3>Add New Product</h3>
        <form
          onSubmit={handleAddProduct}
          style={{ display: "flex", flexDirection: "column", gap: "10px" }}
        >
          <input
            type="text"
            placeholder="Product Name"
            value={product.name}
            onChange={(e) => setProduct({ ...product, name: e.target.value })}
            required
          />
          <input
            type="number"
            placeholder="Price"
            value={product.price}
            onChange={(e) => setProduct({ ...product, price: e.target.value })}
            required
          />
          <input
            type="number"
            placeholder="Initial Stock"
            value={product.stock}
            onChange={(e) => setProduct({ ...product, stock: e.target.value })}
            required
          />
          <button
            type="submit"
            style={{
              backgroundColor: "#28a745",
              color: "white",
              padding: "10px",
            }}
          >
            List Product
          </button>
        </form>
      </div>
    </div>
  );
}
