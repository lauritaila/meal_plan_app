// Importamos los módulos correctamente
import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { corsHeaders } from "../_shared/cors.ts";

// Estructura de la solicitud que esperamos recibir desde Flutter
interface MealPlanRequest {
  user_preferences: Record<string, unknown>;
  plan_requirements: Record<string, unknown>;
  user_comments: string;
}

serve(async (req) => {
  // Manejo de la solicitud pre-vuelo (CORS)
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    // 1. Obtener los datos de la solicitud
    const {
      user_preferences,
      plan_requirements,
      user_comments,
    }: MealPlanRequest = await req.json();

    // 2. Obtener la clave de API de forma segura desde Supabase Vault
    const geminiApiKey = Deno.env.get("GEMINI_API_KEY");
    if (!geminiApiKey) {
      throw new Error("Missing GEMINI_API_KEY in Supabase Vault.");
    }

    // 3. Construir el prompt para Gemini
    const prompt = `
      You are a professional nutritionist and chef. Your task is to generate a highly personalized meal plan based on the user's preferences, requirements, and comments. 
      The response MUST be a valid JSON object that strictly follows the provided schema, without any extra text, explanations, or markdown formatting like \`\`\`json.

      User Preferences: ${JSON.stringify(user_preferences, null, 2)}
      Plan Requirements: ${JSON.stringify(plan_requirements, null, 2)}
      User Comments: "${user_comments}"

      The JSON response must have this exact structure:
      {
        "plan_name": "String",
        "start_date": "YYYY-MM-DD",
        "end_date": "YYYY-MM-DD",
        "daily_meals": [
          {
            "date": "YYYY-MM-DD",
            "meals": [
              {
                "meal_type": "'Breakfast' | 'Lunch' | 'Dinner' | 'Snack'",
                "recipe": {
                  "name": "String",
                  "description": "String",
                  "instructions": "String",
                  "prep_time_minutes": "Integer",
                  "cook_time_minutes": "Integer",
                  "servings": "Integer",
                  "calories": "Decimal",
                  "protein_grams": "Decimal",
                  "carbs_grams": "Decimal",
                  "fats_grams": "Decimal",
                  "ingredients": [
                    {
                      "name": "String",
                      "quantity": "Decimal",
                      "unit": "String"
                    }
                  ]
                }
              }
            ]
          }
        ]
      }
    `;

    // 4. Llamar a la API de Google Gemini
    const model = "gemini-1.5-flash"; // Modelo eficiente y económico
    const url = `https://generativelanguage.googleapis.com/v1beta/models/${model}:generateContent?key=${geminiApiKey}`;

    const response = await fetch(url, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        contents: [{ parts: [{ text: prompt }] }],
        // Forzamos la salida a JSON si el modelo lo soporta
        generationConfig: {
          responseMimeType: "application/json",
        },
      }),
    });

    if (!response.ok) {
      const errorBody = await response.text();
      throw new Error(`Gemini API error: ${response.status} ${errorBody}`);
    }

    const responseData = await response.json();
    // La respuesta de Gemini viene en una estructura diferente a la de OpenAI
    const mealPlanJsonText = responseData.candidates[0].content.parts[0].text;
    const mealPlanJson = JSON.parse(mealPlanJsonText);

    // 5. Devolver la respuesta JSON a la aplicación de Flutter
    return new Response(JSON.stringify(mealPlanJson), {
      headers: { ...corsHeaders, "Content-Type": "application/json" },
      status: 200,
    });

  } catch (error) {
    return new Response(JSON.stringify({ error: error.message }), {
      headers: { ...corsHeaders, "Content-Type": "application/json" },
      status: 500,
    });
  }
});