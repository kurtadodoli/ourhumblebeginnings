# Supabase + PostgreSQL Setup Guide

This guide will help you set up Supabase as the backend for your "Our Humble Beginnings" café mobile app.

## 🚀 Getting Started with Supabase

### Step 1: Create a Supabase Project

1. Go to [supabase.com](https://supabase.com) and sign up/sign in
2. Click "New Project"
3. Choose your organization
4. Fill in your project details:
   - **Name**: Our Humble Beginnings
   - **Database Password**: Choose a strong password
   - **Region**: Select closest to your location
5. Click "Create new project"

### Step 2: Get Your Project Credentials

1. Go to your project dashboard
2. Click on "Settings" in the sidebar
3. Click on "API" under Project Settings
4. Copy the following values:
   - **Project URL** 
   - **Anon (public) key**

### Step 3: Configure Your Flutter App

1. Open `lib/config/supabase_config.dart`
2. Replace the placeholder values:

```dart
class SupabaseConfig {
  static const String supabaseUrl = 'YOUR_ACTUAL_PROJECT_URL_HERE';
  static const String supabaseAnonKey = 'YOUR_ACTUAL_ANON_KEY_HERE';
}
```

### Step 4: Set Up Database Tables

1. Go to your Supabase dashboard
2. Click on "SQL Editor" in the sidebar
3. Create a new query and run the following SQL:

```sql
-- Enable Row Level Security
ALTER DATABASE postgres SET "app.jwt_secret" TO 'your-jwt-secret';

-- Create profiles table for additional user info
CREATE TABLE profiles (
  id UUID REFERENCES auth.users(id) PRIMARY KEY,
  email TEXT,
  full_name TEXT,
  phone TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create menu_items table
CREATE TABLE menu_items (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT,
  price DECIMAL(10,2) NOT NULL,
  category TEXT NOT NULL CHECK (category IN ('coffee', 'food', 'desserts', 'beverages')),
  image_url TEXT,
  is_available BOOLEAN DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create gift_shop_items table
CREATE TABLE gift_shop_items (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT,
  price DECIMAL(10,2) NOT NULL,
  category TEXT,
  image_url TEXT,
  stock_quantity INTEGER DEFAULT 0,
  is_available BOOLEAN DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create rooms table
CREATE TABLE rooms (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT,
  capacity INTEGER NOT NULL,
  hourly_rate DECIMAL(10,2) NOT NULL,
  amenities TEXT[],
  image_url TEXT,
  is_available BOOLEAN DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create reservations table
CREATE TABLE reservations (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES profiles(id),
  room_id UUID REFERENCES rooms(id),
  start_time TIMESTAMP WITH TIME ZONE NOT NULL,
  end_time TIMESTAMP WITH TIME ZONE NOT NULL,
  guest_name TEXT,
  guest_email TEXT,
  guest_phone TEXT,
  total_amount DECIMAL(10,2) NOT NULL,
  status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'confirmed', 'cancelled', 'completed')),
  special_requests TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create orders table
CREATE TABLE orders (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES profiles(id),
  order_type TEXT NOT NULL CHECK (order_type IN ('cafe', 'giftshop')),
  items JSONB NOT NULL,
  total_amount DECIMAL(10,2) NOT NULL,
  status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'confirmed', 'preparing', 'ready', 'completed', 'cancelled')),
  guest_name TEXT,
  guest_email TEXT,
  guest_phone TEXT,
  pickup_time TIMESTAMP WITH TIME ZONE,
  special_instructions TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

### Step 5: Set Up Row Level Security (RLS)

```sql
-- Enable RLS on tables
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE reservations ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;

-- Profiles policies
CREATE POLICY "Users can view own profile" ON profiles 
  FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update own profile" ON profiles 
  FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Users can insert own profile" ON profiles 
  FOR INSERT WITH CHECK (auth.uid() = id);

-- Reservations policies
CREATE POLICY "Users can view own reservations" ON reservations 
  FOR SELECT USING (auth.uid() = user_id OR user_id IS NULL);

CREATE POLICY "Users can create reservations" ON reservations 
  FOR INSERT WITH CHECK (auth.uid() = user_id OR user_id IS NULL);

CREATE POLICY "Users can update own reservations" ON reservations 
  FOR UPDATE USING (auth.uid() = user_id);

-- Orders policies
CREATE POLICY "Users can view own orders" ON orders 
  FOR SELECT USING (auth.uid() = user_id OR user_id IS NULL);

CREATE POLICY "Users can create orders" ON orders 
  FOR INSERT WITH CHECK (auth.uid() = user_id OR user_id IS NULL);

-- Public read access for menu items, gift shop items, and rooms
CREATE POLICY "Anyone can view menu items" ON menu_items 
  FOR SELECT USING (true);

CREATE POLICY "Anyone can view gift shop items" ON gift_shop_items 
  FOR SELECT USING (true);

CREATE POLICY "Anyone can view rooms" ON rooms 
  FOR SELECT USING (true);
```

### Step 6: Insert Sample Data

```sql
-- Sample menu items
INSERT INTO menu_items (name, description, price, category, is_available) VALUES
('Espresso', 'Rich and bold espresso shot', 3.50, 'coffee', true),
('Cappuccino', 'Espresso with steamed milk and foam', 4.75, 'coffee', true),
('Latte', 'Smooth espresso with steamed milk', 5.25, 'coffee', true),
('Croissant', 'Buttery, flaky pastry', 3.25, 'food', true),
('Avocado Toast', 'Fresh avocado on artisan bread', 8.50, 'food', true),
('Chocolate Cake', 'Rich chocolate layer cake', 5.75, 'desserts', true);

-- Sample gift shop items
INSERT INTO gift_shop_items (name, description, price, category, stock_quantity, is_available) VALUES
('Coffee Beans - House Blend', 'Our signature coffee beans', 12.99, 'coffee', 50, true),
('Ceramic Mug', 'Handmade ceramic mug', 15.99, 'accessories', 25, true),
('Coffee Grinder', 'Manual coffee grinder', 45.99, 'equipment', 10, true);

-- Sample rooms
INSERT INTO rooms (name, description, capacity, hourly_rate, amenities, is_available) VALUES
('The Cozy Corner', 'Intimate space perfect for small meetings', 4, 25.00, ARRAY['WiFi', 'Whiteboard', 'Coffee'], true),
('The Garden Room', 'Bright room with garden views', 8, 40.00, ARRAY['WiFi', 'Projector', 'Coffee', 'Natural Light'], true),
('The Library Nook', 'Quiet space for focused work', 6, 35.00, ARRAY['WiFi', 'Books', 'Coffee', 'Quiet Zone'], true);
```

### Step 7: Set Up Authentication

1. In your Supabase dashboard, go to "Authentication" > "Settings"
2. Configure your authentication settings:
   - **Site URL**: Your app's URL (for development: http://localhost:3000)
   - **Redirect URLs**: Add any redirect URLs you need
3. Enable email confirmation if desired
4. Configure any social auth providers you want to use

### Step 8: Configure Storage (Optional)

If you want to store images:

1. Go to "Storage" in your Supabase dashboard
2. Create a new bucket called "images"
3. Set up policies for public read access:

```sql
-- Allow public read access to images
CREATE POLICY "Public read access" ON storage.objects 
  FOR SELECT USING (bucket_id = 'images');

-- Allow authenticated users to upload images
CREATE POLICY "Authenticated users can upload" ON storage.objects 
  FOR INSERT WITH CHECK (bucket_id = 'images' AND auth.role() = 'authenticated');
```

## 🔧 Environment Variables

For production, consider using environment variables for your Supabase credentials:

1. Create a `.env` file in your project root:
```
SUPABASE_URL=your_project_url
SUPABASE_ANON_KEY=your_anon_key
```

2. Add `.env` to your `.gitignore` file

3. Use flutter_dotenv package to load environment variables

## 🛡️ Security Best Practices

1. **Never commit your Supabase credentials** to version control
2. **Use Row Level Security (RLS)** for all tables with user data
3. **Validate data** on both client and server side
4. **Use the anon key** for public operations only
5. **Implement proper error handling** for auth failures

## 📱 Testing Your Setup

1. Run your Flutter app: `flutter run`
2. Try creating an account
3. Test guest mode functionality
4. Check that data is being saved to Supabase

## 🆘 Troubleshooting

### Common Issues:

1. **"Invalid API key"**: Check that you've copied the correct anon key
2. **"Connection failed"**: Verify your project URL is correct
3. **"Row Level Security violation"**: Check your RLS policies
4. **"Email not confirmed"**: Check your auth settings

### Getting Help:

- [Supabase Documentation](https://supabase.com/docs)
- [Supabase Discord](https://discord.supabase.com)
- [Flutter Supabase Package](https://pub.dev/packages/supabase_flutter)

## 🎉 You're All Set!

Your "Our Humble Beginnings" app now has a full backend with:
- ✅ User Authentication (Email/Password + Guest Mode)
- ✅ PostgreSQL Database with all necessary tables
- ✅ Row Level Security for data protection
- ✅ Real-time subscriptions (if needed)
- ✅ File storage (if configured)

Happy coding! ☕️
