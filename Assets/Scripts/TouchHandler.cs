using System;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;

[RequireComponent(typeof(RectTransform))]
[RequireComponent(typeof(Image))]
public class TouchHandler : MonoBehaviour, IPointerDownHandler, IPointerUpHandler, IPointerMoveHandler, IPointerEnterHandler,IPointerExitHandler
{
    public Text text;
    // 缓存 Canvas 和 Camera 以提高性能
    private Canvas _parentCanvas;
    private Camera _eventCamera;
    private Image imageComponent;

    private void Awake()
    {
        // 获取父级 Canvas 和关联的相机
        _parentCanvas = GetComponentInParent<Canvas>();
        if (_parentCanvas == null)
        {
            Debug.LogError("此 UI 元素不在 Canvas 下！", this);
            enabled = false;
            return;
        }
        
        // 获取用于渲染此 Canvas 的相机
        _eventCamera = _parentCanvas.worldCamera;
        if (_eventCamera == null && _parentCanvas.renderMode != RenderMode.ScreenSpaceOverlay)
        {
            Debug.LogError("Canvas 的 World Camera 未设置！", this);
            enabled = false;
        }
    }
    void Start()
    {

        // 2. 获取并实例化材质
        // .material 属性会自动创建一个新的材质实例
        imageComponent = GetComponent<Image>();
        if (imageComponent != null)
        {
            var rect = GetComponent<RectTransform>();
            imageComponent.material = new Material(imageComponent.material);
            imageComponent.material.SetVector("_Size", new Vector2(rect.rect.width,rect.rect.height));
        }
    }

    public void OnPointerDown(PointerEventData eventData)
    {
        if(eventData.pointerEnter != gameObject) return;
        LogNormalizedPositionFromRay(eventData, "OnPointerDown");
    }

    public void OnPointerUp(PointerEventData eventData)
    {
        if(eventData.pointerEnter != gameObject) return;
        LogNormalizedPositionFromRay(eventData, "OnPointerUp");
    }
    public void OnPointerMove(PointerEventData eventData)
    {
        // Debug.Log(eventData.pointerEnter.gameObject);
        if(eventData.pointerEnter != gameObject) return;
        LogNormalizedPositionFromRay(eventData, "OnPointerMove");
    }
    public void OnPointerEnter(PointerEventData eventData)
    {
        imageComponent.material.SetFloat("_Radius",0.2f);
    }

    public void OnPointerExit(PointerEventData eventData)
    {
        imageComponent.material.SetFloat("_Radius",0);
    }
    /// <summary>
    /// 从射线计算并记录归一化位置
    /// </summary>
    private void LogNormalizedPositionFromRay(PointerEventData eventData, string eventName)
    {
        // 1. 从 PointerEventData 获取射线
        // 对于 XRUIInputModule，eventData.pressEventCamera 就是用于射线的相机
        Ray ray = new(_eventCamera.transform.position, _eventCamera.transform.forward);

        // 对于更复杂的 XR 设置，可能需要从 eventData 的特定字段获取射线
        // 但在大多数标准配置下，eventData.pointerCurrentRaycast.worldPosition 和 .worldNormal
        // 已经是 Unity 为我们计算好的射线与UI的交点信息。
        Debug.Log(eventData.pointerEnter);
        if (eventData.pointerCurrentRaycast.isValid == false || eventData.pointerEnter != gameObject)
        {
            text.text = "";
            
            // 如果射线没有击中任何东西，直接返回
            return;
        }
        
        // 2. 获取射线与UI平面相交的3D世界坐标
        // pointerCurrentRaycast.worldPosition 是 Unity 提供的、最可靠的交点
        Vector3 worldHitPoint = eventData.pointerCurrentRaycast.worldPosition;

        // 3. 将这个3D世界坐标转换为UI元素的本地坐标
        // 我们需要一个从世界到本地的转换矩阵
        RectTransform rectTransform = GetComponent<RectTransform>();
        Matrix4x4 worldToLocalMatrix = rectTransform.worldToLocalMatrix;
        Vector2 localPoint = worldToLocalMatrix.MultiplyPoint3x4(worldHitPoint);

        // 4. 计算归一化坐标
        Vector2 normalizedPoint = NormalizePoint(localPoint, rectTransform.rect);
        imageComponent.material.SetVector("_PointPos",normalizedPoint);
        // 5. 输出结果
        string msg = $"[{eventName}] 元素内归一化坐标: X={normalizedPoint.x:F2}, Y={normalizedPoint.y:F2}";
        // Debug.Log(msg, this.gameObject);

        if (text != null)
        {
            text.text = msg;
        }
    }

    /// <summary>
    /// 将一个点在指定Rect内的坐标归一化到 [0, 1] 范围
    /// </summary>
    private Vector2 NormalizePoint(Vector2 point, Rect rect)
    {
        // 将点从以中心为原点的坐标系，转换到以左下角为原点的坐标系
        Vector2 bottomLeftOriginPoint = point - rect.position;

        // 分别除以宽和高，得到归一化坐标
        float normalizedX = bottomLeftOriginPoint.x / rect.width;
        float normalizedY = bottomLeftOriginPoint.y / rect.height;

        return new Vector2(normalizedX, normalizedY);
    }
}
