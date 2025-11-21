Shader "Unlit/CircleOnBackground"
{
    Properties
    {
        // 背景颜色，默认为白色
        _BackgroundColor ("Background Color", Color) = (1,1,1,1)
        // 圆点的颜色，默认为黑色
        _PointColor ("Point Color", Color) = (0,0,0,1)
        // 圆点的中心位置 (UV坐标)，默认为(0.5, 0.5)即中心
        _PointPos ("Point Position (UV)", Vector) = (0.5, 0.5, 0, 0)
        // 圆点的半径 (归一化值)，默认为0.2
        _Size ("Size", Vector) = (1, 1, 0, 0)
        _Radius ("Radius", Range(0, 0.5)) = 0.0
        // 边缘的柔和度/过渡宽度，值越大边缘越模糊
        _Softness ("Edge Softness", Range(0, 0.5)) = 0.05
    }
    SubShader
    {
        Tags { "Queue"="Transparent" "RenderType"="Transparent" }
        LOD 100

        Pass
        {
            Blend SrcAlpha OneMinusSrcAlpha
            ZWrite Off
            Cull Off
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            // 从 Properties 中定义的变量
            fixed4 _BackgroundColor;
            fixed4 _PointColor;
            float2 _PointPos;
            float2 _Size;
            float _Softness;
            float _Radius;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // 1. 计算当前像素到圆心点的距离
                float radio = _Size.x/_Size.y;
                float2 uv = i.uv ;
                uv.x *= radio;
                float r = 100/max(_Size.x/radio,_Size.y)*_Radius;
                float s = 100/max(_Size.x/radio,_Size.y)*_Softness;
                // uv += _PointPos;
                // uv +=float2(_PointPos.x*_Radio,_PointPos.y);
                float dist = distance(uv, float2(_PointPos.x*radio,_PointPos.y));
                float circleMask = smoothstep(r , r - s, dist);
                fixed4 finalColor = _BackgroundColor +lerp(0, _PointColor, circleMask);

                return finalColor;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}
