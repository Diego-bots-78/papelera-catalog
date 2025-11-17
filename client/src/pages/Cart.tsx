import { Button } from "@/components/ui/button";
import { Card } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Trash2, ArrowLeft, MessageCircle } from "lucide-react";
import { useCart } from "@/contexts/CartContext";
import { useLocation } from "wouter";

const MINIMUM_ORDER = 30000; // Mínimo de envío en pesos
const DISCOUNT_THRESHOLD = 100000; // Monto para aplicar descuento
const DISCOUNT_PERCENTAGE = 0.1; // 10% de descuento

export default function Cart() {
  const { items, removeItem, updateQuantity, clearCart, total } = useCart();
  const [, setLocation] = useLocation();
  const remaining = Math.max(0, MINIMUM_ORDER - total);
  
  // Calcular descuento
  const hasDiscount = total >= DISCOUNT_THRESHOLD;
  const discountAmount = hasDiscount ? Math.round(total * DISCOUNT_PERCENTAGE) : 0;
  const finalTotal = total - discountAmount;

  const formatPrice = (price: number) => {
    return new Intl.NumberFormat("es-AR", {
      style: "currency",
      currency: "ARS",
      minimumFractionDigits: 0,
      maximumFractionDigits: 0,
    }).format(price);
  };

  const handleSendToWhatsApp = () => {
    if (items.length === 0) return;
    if (total < MINIMUM_ORDER) return;

    let message = "Hola, me gustaría hacer un pedido:\n\n";
    items.forEach((item) => {
      message += `• ${item.nombre} (${item.medida})\n`;
      message += `  Cantidad: ${item.cantidad}\n`;
      message += `  Precio unitario: ${formatPrice(item.precio)}\n`;
      message += `  Subtotal: ${formatPrice(item.precio * item.cantidad)}\n\n`;
    });
    message += `Subtotal: ${formatPrice(total)}\n`;
    if (hasDiscount) {
      message += `Descuento 10%: -${formatPrice(discountAmount)}\n`;
    }
    message += `TOTAL: ${formatPrice(finalTotal)}\n\n`;
    message += "Por favor, confirmar disponibilidad y enviar presupuesto.";

    const encodedMessage = encodeURIComponent(message);
    const whatsappUrl = `https://wa.me/541134684452?text=${encodedMessage}`;
    window.open(whatsappUrl, "_blank");
  };

  return (
    <div className="min-h-screen bg-gradient-to-b from-blue-50 to-white">
      {/* Header */}
      <div className="sticky top-0 z-40 bg-white border-b border-gray-200 shadow-sm">
        <div className="max-w-6xl mx-auto px-4 py-4">
          <div className="flex items-center gap-3 mb-4">
            <Button
              variant="ghost"
              size="sm"
              onClick={() => setLocation("/")}
              className="mr-2"
            >
              <ArrowLeft className="w-4 h-4" />
            </Button>
            <div className="w-10 h-10 bg-blue-600 rounded-lg flex items-center justify-center">
              <span className="text-white font-bold text-lg">P</span>
            </div>
            <div>
              <h1 className="text-2xl font-bold text-gray-900">Mi Carrito</h1>
              <p className="text-sm text-gray-600">{items.length} productos</p>
            </div>
          </div>
        </div>
      </div>

      {/* Main Content */}
      <div className="max-w-6xl mx-auto px-4 py-8">
        {items.length === 0 ? (
          <div className="text-center py-12">
            <p className="text-gray-500 text-lg mb-4">Tu carrito está vacío</p>
            <Button onClick={() => setLocation("/")} className="bg-blue-600">
              Volver al catálogo
            </Button>
          </div>
        ) : (
          <div className="grid gap-6 lg:grid-cols-3">
            {/* Cart Items */}
            <div className="lg:col-span-2 space-y-4">
              {items.map((item) => (
                <Card key={item.id} className="p-4">
                  <div className="flex gap-4">
                    <div className="flex-1">
                      <h3 className="font-semibold text-gray-900">
                        {item.nombre}
                      </h3>
                      <p className="text-sm text-gray-600 mt-1">{item.medida}</p>
                      <p className="text-sm text-gray-600 mt-1">
                        Categoría: {item.categoria}
                      </p>
                      <p className="text-lg font-bold text-blue-600 mt-2">
                        {formatPrice(item.precio)}
                      </p>
                    </div>

                    <div className="flex flex-col items-end gap-3">
                      <div className="flex items-center gap-2 bg-gray-100 rounded-lg p-2">
                        <button
                          onClick={() =>
                            updateQuantity(item.id, item.cantidad - 1)
                          }
                          className="px-2 py-1 text-gray-600 hover:text-gray-900"
                        >
                          −
                        </button>
                        <Input
                          type="number"
                          value={item.cantidad}
                          onChange={(e) =>
                            updateQuantity(item.id, parseInt(e.target.value) || 1)
                          }
                          className="w-12 text-center border-0 bg-transparent"
                          min="1"
                        />
                        <button
                          onClick={() =>
                            updateQuantity(item.id, item.cantidad + 1)
                          }
                          className="px-2 py-1 text-gray-600 hover:text-gray-900"
                        >
                          +
                        </button>
                      </div>

                      <p className="font-semibold text-gray-900">
                        {formatPrice(item.precio * item.cantidad)}
                      </p>

                      <Button
                        variant="ghost"
                        size="sm"
                        onClick={() => removeItem(item.id)}
                        className="text-red-600 hover:text-red-700 hover:bg-red-50"
                      >
                        <Trash2 className="w-4 h-4" />
                      </Button>
                    </div>
                  </div>
                </Card>
              ))}
            </div>

            {/* Summary */}
            <div className="lg:col-span-1">
              <Card className="p-6 sticky top-24">
                <h2 className="text-lg font-bold text-gray-900 mb-4">
                  Resumen del Pedido
                </h2>

                <div className="space-y-3 mb-6 pb-6 border-b border-gray-200">
                  <div className="flex justify-between text-sm">
                    <span className="text-gray-600">Subtotal</span>
                    <span className="font-semibold text-gray-900">
                      {formatPrice(total)}
                    </span>
                  </div>
                  <div className="flex justify-between text-sm">
                    <span className="text-gray-600">Productos</span>
                    <span className="font-semibold text-gray-900">
                      {items.length}
                    </span>
                  </div>
                  <div className="flex justify-between text-sm">
                    <span className="text-gray-600">Mínimo de envío</span>
                    <span className="font-semibold text-gray-900">
                      {formatPrice(MINIMUM_ORDER)}
                    </span>
                  </div>
                </div>

                {total < MINIMUM_ORDER && (
                  <div className="mb-6 p-4 bg-yellow-50 border border-yellow-200 rounded-lg">
                    <p className="text-sm font-semibold text-yellow-800 mb-2">
                      ⚠️ Mínimo de envío no alcanzado
                    </p>
                    <p className="text-sm text-yellow-700">
                      Faltan <span className="font-bold">{formatPrice(remaining)}</span> para alcanzar el mínimo de envío de {formatPrice(MINIMUM_ORDER)}
                    </p>
                  </div>
                )}

                {hasDiscount && (
                  <div className="mb-6 p-4 bg-green-50 border border-green-200 rounded-lg">
                    <p className="text-sm font-semibold text-green-800 mb-2">
                      🎉 ¡Descuento Aplicado!
                    </p>
                    <p className="text-sm text-green-700">
                      10% de descuento por compra mayor a {formatPrice(DISCOUNT_THRESHOLD)}
                    </p>
                    <p className="text-sm text-green-700 mt-1">
                      Ahorras: <span className="font-bold">{formatPrice(discountAmount)}</span>
                    </p>
                  </div>
                )}

                <div className="flex justify-between text-lg font-bold mb-6">
                  <span>Total</span>
                  <span className="text-blue-600">{formatPrice(finalTotal)}</span>
                </div>

                <div className="space-y-3">
                  <Button
                    className="w-full bg-green-600 hover:bg-green-700 disabled:bg-gray-400 disabled:cursor-not-allowed"
                    onClick={handleSendToWhatsApp}
                    disabled={total < MINIMUM_ORDER}
                  >
                    <MessageCircle className="w-4 h-4 mr-2" />
                    Enviar Pedido a WhatsApp
                  </Button>

                  <Button
                    variant="outline"
                    className="w-full"
                    onClick={() => setLocation("/")}
                  >
                    Seguir Comprando
                  </Button>

                  <Button
                    variant="ghost"
                    className="w-full text-red-600 hover:text-red-700"
                    onClick={clearCart}
                  >
                    Vaciar Carrito
                  </Button>
                </div>
              </Card>
            </div>
          </div>
        )}
      </div>
    </div>
  );
}
