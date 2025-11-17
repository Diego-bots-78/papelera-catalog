import { useState, useMemo, useRef, useEffect } from "react";
import { useAuth } from "@/_core/hooks/useAuth";
import { Button } from "@/components/ui/button";
import { Card } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { ChevronDown, Phone, MessageCircle, ShoppingCart, ChevronUp } from "lucide-react";
import { useLocation } from "wouter";
import { useCart } from "@/contexts/CartContext";
import productsData from "@/data/products.json";

interface Producto {
  id: string;
  nombre: string;
  medida: string;
  precio: number;
  categoria: string;
  imagen: string;
  descripcion: string;
}

export default function Home() {
  // The userAuth hooks provides authentication state
  // To implement login/logout functionality, simply call logout() or redirect to getLoginUrl()
  const { user, loading, error, isAuthenticated, logout } = useAuth();

  const [searchTerm, setSearchTerm] = useState("");
  const [selectedCategory, setSelectedCategory] = useState<string | null>(null);
  const [expandedProducts, setExpandedProducts] = useState<Set<string>>(new Set());
  const [, setLocation] = useLocation();
  const { items, addItem, total } = useCart();
  const categoryRefs = useRef<{ [key: string]: HTMLDivElement | null }>({});

  // Obtener productos del JSON
  const productos: Producto[] = productsData.productos || [];
  const categorias = useMemo(() => {
    return Array.from(new Set(productos.map((p) => p.categoria))).sort();
  }, [productos]);

  // Filtrar productos por búsqueda y categoría
  const filteredProducts = useMemo(() => {
    return productos.filter((producto) => {
      const matchesSearch =
        searchTerm === "" ||
        producto.nombre.toLowerCase().includes(searchTerm.toLowerCase()) ||
        producto.categoria.toLowerCase().includes(searchTerm.toLowerCase()) ||
        producto.medida.toLowerCase().includes(searchTerm.toLowerCase());

      const matchesCategory =
        selectedCategory === null || producto.categoria === selectedCategory;

      return matchesSearch && matchesCategory;
    });
  }, [productos, searchTerm, selectedCategory]);

  // Agrupar productos por categoría para mostrar una imagen por categoría
  const groupedByCategory = useMemo(() => {
    const groups: { [key: string]: Producto[] } = {};
    filteredProducts.forEach((p) => {
      if (!groups[p.categoria]) {
        groups[p.categoria] = [];
      }
      groups[p.categoria].push(p);
    });
    return groups;
  }, [filteredProducts]);

  // Scroll automático cuando se selecciona una categoría
  useEffect(() => {
    if (selectedCategory && categoryRefs.current[selectedCategory]) {
      setTimeout(() => {
        categoryRefs.current[selectedCategory]?.scrollIntoView({
          behavior: "smooth",
          block: "start",
        });
      }, 100);
    }
  }, [selectedCategory]);

  const toggleExpanded = (categoryName: string) => {
    const newExpanded = new Set(expandedProducts);
    if (newExpanded.has(categoryName)) {
      newExpanded.delete(categoryName);
    } else {
      newExpanded.add(categoryName);
    }
    setExpandedProducts(newExpanded);
  };

  const formatPrice = (price: number) => {
    return new Intl.NumberFormat("es-AR", {
      style: "currency",
      currency: "ARS",
      minimumFractionDigits: 0,
      maximumFractionDigits: 0,
    }).format(price);
  };

  return (
    <div className="min-h-screen bg-gradient-to-b from-blue-50 to-white">
      {/* Hero Header with Background Image */}
      <div className="relative bg-white border-b border-gray-200 shadow-md">
        <div
          className="absolute inset-0 bg-cover bg-center opacity-20"
          style={{
            backgroundImage: "url('/images/papelera_hero.jpg')",
          }}
        />
        <div className="relative z-10">
          {/* Top Navigation */}
          <div className="sticky top-0 z-40 bg-white/95 backdrop-blur border-b border-gray-200 shadow-sm">
            <div className="max-w-6xl mx-auto px-4 py-3 flex items-center justify-between">
              <div className="flex items-center gap-3">
                <div className="w-10 h-10 bg-blue-600 rounded-lg flex items-center justify-center">
                  <span className="text-white font-bold text-lg">P</span>
                </div>
                <div>
                  <h1 className="text-2xl font-bold text-gray-900">PAPELERA</h1>
                  <p className="text-xs text-gray-600">Catálogo de Precios</p>
                </div>
              </div>
              <div className="flex flex-col items-end gap-1">
                {items.length === 0 ? (
                  <div className="text-xs text-gray-600 font-medium">Carrito vacío</div>
                ) : (
                  <div className="text-xs text-gray-700 font-semibold">
                    {items.length} producto{items.length !== 1 ? 's' : ''}
                  </div>
                )}
                <Button
                  onClick={() => setLocation("/cart")}
                  className="bg-blue-600 hover:bg-blue-700 relative"
                  size="sm"
                >
                  <ShoppingCart className="w-4 h-4 mr-2" />
                  {items.length > 0 ? 'Confirmar compra' : 'Carrito'}
                  {items.length > 0 && (
                    <span className="absolute -top-2 -right-2 bg-red-500 text-white text-xs rounded-full w-5 h-5 flex items-center justify-center font-bold">
                      {items.length}
                    </span>
                  )}
                </Button>
              </div>
            </div>
          </div>

          {/* Hero Section */}
          <div className="max-w-6xl mx-auto px-4 py-12 text-center">
            <h2 className="text-4xl md:text-5xl font-bold text-gray-900 mb-2">
              PAPELERA
            </h2>
            <p className="text-lg text-gray-700 mb-1">
              ✈️ Envíos a todo el país
            </p>
            <p className="text-base text-gray-600 mb-6">
              Tu consulta siempre es bienvenida
            </p>

            {/* Search */}
            <div className="max-w-2xl mx-auto">
              <Input
                type="text"
                placeholder="Buscar: bolsa, bobina, bandeja, vasos..."
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
                className="w-full"
              />
            </div>
          </div>
        </div>
      </div>

      {/* Main Content */}
      <div className="max-w-6xl mx-auto px-4 py-8">
        {/* Category Filters */}
        <div className="mb-8 flex flex-wrap gap-2">
          <Button
            variant={selectedCategory === null ? "default" : "outline"}
            onClick={() => setSelectedCategory(null)}
            className="rounded-full"
          >
            Todos
          </Button>
          {categorias.map((cat) => (
            <Button
              key={cat}
              variant={selectedCategory === cat ? "default" : "outline"}
              onClick={() => {
                setSelectedCategory(cat);
                // Scroll automático
                setTimeout(() => {
                  const element = document.getElementById(`category-${cat}`);
                  if (element) {
                    element.scrollIntoView({ behavior: "smooth", block: "start" });
                  }
                }, 100);
              }}
              className="rounded-full text-sm"
            >
              {cat}
            </Button>
          ))}
        </div>

        {/* Results Count */}
        <div className="mb-6 text-sm text-gray-600">
          {filteredProducts.length} productos encontrados
        </div>

        {/* Products Grid */}
        {Object.keys(groupedByCategory).length === 0 ? (
          <div className="text-center py-12">
            <p className="text-gray-500 text-lg">No se encontraron productos</p>
            <p className="text-gray-400 text-sm mt-2">
              Intenta con otros términos de búsqueda
            </p>
          </div>
        ) : (
          <div className="grid gap-6">
            {Object.entries(groupedByCategory).map(([categoryName, categoryItems]) => {
              const isExpanded = expandedProducts.has(categoryName);
              const firstItem = categoryItems[0];

              return (
                <Card
                  key={categoryName}
                  id={`category-${categoryName}`}
                  ref={(el) => {
                    if (el) categoryRefs.current[categoryName] = el;
                  }}
                  className="overflow-hidden hover:shadow-lg transition-shadow"
                >
                  {/* Boton Volver al Menu */}
                  {selectedCategory === categoryName && (
                    <div className="bg-blue-600 px-6 py-4 sticky top-0 z-50">
                      <Button
                        size="lg"
                        onClick={() => {
                          setSelectedCategory(null);
                          window.scrollTo({ top: 0, behavior: 'smooth' });
                        }}
                        className="w-full bg-white text-blue-600 hover:bg-gray-100 font-bold text-base"
                      >
                        <ChevronUp className="w-5 h-5 mr-2" />
                        Volver al menu principal
                      </Button>
                    </div>
                  )}
                  {/* Category Image and Header */}
                  <div className="grid md:grid-cols-2 gap-6 p-6">
                    {/* Image */}
                    <div className="flex items-center justify-center bg-gray-100 rounded-lg min-h-64">
                      <img
                        src={firstItem.imagen}
                        alt={categoryName}
                        className="w-full h-full object-cover rounded-lg"
                        onError={(e) => {
                          (e.target as HTMLImageElement).src =
                            "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='200' height='200'%3E%3Crect fill='%23f3f4f6' width='200' height='200'/%3E%3Ctext x='50%25' y='50%25' font-size='14' fill='%239ca3af' text-anchor='middle' dy='.3em'%3EImagen no disponible%3C/text%3E%3C/svg%3E";
                        }}
                      />
                    </div>

                    {/* Category Info and Products */}
                    <div>
                      <h2 className="text-xl font-bold text-gray-900 mb-2">
                        {categoryName}
                      </h2>
                      <p className="text-gray-600 text-sm mb-6">
                        {firstItem.descripcion}
                      </p>

                      {/* Show first item or all items */}
                      <div className="space-y-3 mb-6">
                        {(isExpanded ? categoryItems : categoryItems.slice(0, 1)).map((item) => (
                          <div
                            key={item.id}
                            className="bg-gray-50 p-4 rounded-lg border border-gray-200"
                          >
                            <div className="flex justify-between items-start gap-4">
                              <div className="flex-1">
                                <p className="font-semibold text-gray-900">
                                  {item.nombre}
                                </p>
                                {item.medida && (
                                  <p className="text-sm text-gray-600 mt-1">
                                    {item.medida}
                                  </p>
                                )}
                              </div>
                              <div className="flex items-center gap-2">
                                <p className="text-lg font-bold text-blue-600">
                                  {formatPrice(item.precio)}
                                </p>
                                <div className="relative">
                                  <Button
                                    size="sm"
                                    className="bg-blue-600 hover:bg-blue-700"
                                    onClick={() => {
                                      addItem(
                                        {
                                          id: item.id,
                                          nombre: item.nombre,
                                          medida: item.medida,
                                          precio: item.precio,
                                          categoria: item.categoria,
                                        },
                                        1
                                      );
                                    }}
                                  >
                                    <ShoppingCart className="w-4 h-4" />
                                  </Button>
                                  {items.find(cartItem => cartItem.id === item.id) && (
                                    <span className="absolute -top-2 -right-2 bg-red-500 text-white text-xs font-bold rounded-full w-5 h-5 flex items-center justify-center">
                                      {items.find(cartItem => cartItem.id === item.id)?.cantidad || 0}
                                    </span>
                                  )}
                                </div>
                              </div>
                            </div>
                          </div>
                        ))}
                      </div>

                      {/* Show more button */}
                      {categoryItems.length > 1 && (
                        <Button
                          variant="ghost"
                          onClick={() => toggleExpanded(categoryName)}
                          className="w-full mb-6 text-blue-600 hover:text-blue-700"
                        >
                          <ChevronDown
                            className={`w-4 h-4 mr-2 transition-transform ${
                              isExpanded ? "rotate-180" : ""
                            }`}
                          />
                          {isExpanded
                            ? "Ver menos opciones"
                            : `Ver ${categoryItems.length - 1} más opciones`}
                        </Button>
                      )}

                      {/* Contact Buttons */}
                      <div className="flex gap-3">
                        <Button
                          className="flex-1 bg-green-600 hover:bg-green-700"
                          onClick={() => {
                            const message = encodeURIComponent(
                              `Hola, me interesa consultar sobre ${categoryName}`
                            );
                            window.open(
                              `https://wa.me/541134684452?text=${message}`,
                              "_blank"
                            );
                          }}
                        >
                          <MessageCircle className="w-4 h-4 mr-2" />
                          WhatsApp
                        </Button>
                        <Button
                          variant="outline"
                          className="flex-1"
                          onClick={() => {
                            window.location.href = "tel:+541134684452";
                          }}
                        >
                          <Phone className="w-4 h-4 mr-2" />
                          Llamar
                        </Button>
                      </div>
                    </div>
                  </div>
                </Card>
              );
            })}
          </div>
        )}
      </div>

      {/* Floating Cart Button - Visible when viewing products */}
      {items.length > 0 && selectedCategory && (
        <div className="fixed bottom-6 right-6 z-40">
          <Button
            onClick={() => setLocation("/cart")}
            className="bg-blue-600 hover:bg-blue-700 text-white font-bold py-3 px-6 rounded-full shadow-lg flex items-center gap-2 animate-pulse"
          >
            <ShoppingCart className="w-5 h-5" />
            <span>
              {items.length} - {formatPrice(total)}
            </span>
          </Button>
        </div>
      )}
    </div>
  );
}