/*!
 * File TPVector2D.h
 */


#pragma once

//
//  TPVector2D.h
//
//  Copyright (c) 2015 Khaled Garbaya
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.


#include <cmath>

namespace tp
{
    class Vector2D
    {
    public:
        Vector2D(float x, float y) : m_x(x), m_y(y)
        {}

        float getX()
        { return m_x; }

        float getY()
        { return m_y; }

        void setX(float x)
        { m_x = x; }

        void setY(float y)
        { m_y = y; }

        float length() const;

        void normalize();

        ///----------------------------------------------Operators overloading ------------------------------------------------------------
        /// + and += operators
        Vector2D operator+(const Vector2D& v2) const;

        Vector2D& operator+=(const Vector2D& v2);

        /// * and *= operator
        Vector2D operator*(float scalar) const;

        Vector2D& operator*=(float scalar);

        /// - and -= operator
        Vector2D operator-(const Vector2D& v2) const;

        Vector2D& operator-=(const Vector2D& v2);

        /// / and /= operator
        Vector2D operator/(float scalar) const;

        Vector2D& operator/=(float scalar);

    private:
        float m_x;
        float m_y;
    };
}