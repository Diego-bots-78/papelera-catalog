import { COOKIE_NAME } from "@shared/const";
import { getSessionCookieOptions } from "./_core/cookies";
import { systemRouter } from "./_core/systemRouter";
import { publicProcedure, router, protectedProcedure } from "./_core/trpc";
import { z } from "zod";
import { getAllProducts, getProductsByCategory, createOrder, getOrderItems, createOrderItem } from "./db";
import { storagePut } from "./storage";

export const appRouter = router({
  system: systemRouter,
  auth: router({
    me: publicProcedure.query(opts => opts.ctx.user),
    logout: publicProcedure.mutation(({ ctx }) => {
      const cookieOptions = getSessionCookieOptions(ctx.req);
      ctx.res.clearCookie(COOKIE_NAME, { ...cookieOptions, maxAge: -1 });
      return {
        success: true,
      } as const;
    }),
  }),

  products: router({
    list: publicProcedure.query(async () => {
      return await getAllProducts();
    }),
    byCategory: publicProcedure.input(z.object({ categoria: z.string() })).query(async ({ input }) => {
      return await getProductsByCategory(input.categoria);
    }),
  }),

  orders: router({
    create: protectedProcedure
      .input(z.object({
        clientName: z.string(),
        clientPhone: z.string(),
        clientEmail: z.string().optional(),
        totalPrice: z.number(),
        items: z.array(z.object({
          productId: z.number(),
          quantity: z.number(),
          priceAtTime: z.number(),
        })),
      }))
      .mutation(async ({ ctx, input }) => {
        const order = await createOrder({
          userId: ctx.user?.id,
          clientName: input.clientName,
          clientPhone: input.clientPhone,
          clientEmail: input.clientEmail,
          totalPrice: input.totalPrice,
          status: "pending",
        });
        
        // Create order items
        const orderId = (order as any).insertId as number;
        for (const item of input.items) {
          await createOrderItem({
            orderId: orderId,
            productId: item.productId,
            quantity: item.quantity,
            priceAtTime: item.priceAtTime,
          });
        }
        
        return { orderId };
      }),
    getById: publicProcedure.input(z.object({ orderId: z.number() })).query(async ({ input }) => {
      const items = await getOrderItems(input.orderId);
      return items;
    }),
  }),

  storage: router({
    uploadImage: protectedProcedure
      .input(z.object({
        filename: z.string(),
        data: z.string(), // base64 encoded image
        contentType: z.string(),
      }))
      .mutation(async ({ input }) => {
        const buffer = Buffer.from(input.data, 'base64');
        const fileKey = `products/${Date.now()}-${input.filename}`;
        const result = await storagePut(fileKey, buffer, input.contentType);
        return result;
      }),
  }),
});

export type AppRouter = typeof appRouter;
