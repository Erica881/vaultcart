"use client";

import { createContext, useContext, useState, useMemo } from "react";

export type CartItem = {
  productId: number;
  name: string;
  price: number;
  quantity: number;
  checked: boolean;
};

type CartContextType = {
  cart: CartItem[];
  totalAmount: number; // New: To keep track of the price
  addToCart: (item: Omit<CartItem, "checked">) => void;
  increaseQty: (productId: number) => void;
  decreaseQty: (productId: number) => void;
  toggleItem: (productId: number) => void;
  removeSelected: () => void;
};

const CartContext = createContext<CartContextType | null>(null);

export function CartProvider({ children }: { children: React.ReactNode }) {
  const [cart, setCart] = useState<CartItem[]>([]);

  // Calculate total only for CHECKED items
  const totalAmount = useMemo(() => {
    return cart
      .filter((item) => item.checked)
      .reduce((sum, item) => sum + item.price * item.quantity, 0);
  }, [cart]);

  const addToCart = (item: Omit<CartItem, "checked">) => {
    setCart((prev) => {
      const existing = prev.find((p) => p.productId === item.productId);
      if (existing) {
        return prev.map((p) =>
          p.productId === item.productId
            ? { ...p, quantity: p.quantity + 1 }
            : p
        );
      }
      return [...prev, { ...item, checked: true }];
    });
  };

  const increaseQty = (id: number) => {
    setCart((prev) =>
      prev.map((p) =>
        p.productId === id ? { ...p, quantity: p.quantity + 1 } : p
      )
    );
  };

  const decreaseQty = (id: number) => {
    setCart((prev) =>
      prev.map((p) =>
        p.productId === id ? { ...p, quantity: Math.max(1, p.quantity - 1) } : p
      )
    );
  };

  const toggleItem = (id: number) => {
    setCart((prev) =>
      prev.map((p) => (p.productId === id ? { ...p, checked: !p.checked } : p))
    );
  };

  const removeSelected = () => {
    setCart((prev) => prev.filter((p) => !p.checked));
  };

  return (
    <CartContext.Provider
      value={{
        cart,
        totalAmount,
        addToCart,
        increaseQty,
        decreaseQty,
        toggleItem,
        removeSelected,
      }}
    >
      {children}
    </CartContext.Provider>
  );
}

export function useCart() {
  const ctx = useContext(CartContext);
  if (!ctx) throw new Error("useCart must be inside CartProvider");
  return ctx;
}
