using UnityEngine;
using Cinemachine;

public class CinemachinePOVExtension : CinemachineExtension
{
    [SerializeField]
    private float horizontalSpeed = 10f;
    [SerializeField]
    private float verticalSpeed = 10f;
    [SerializeField]
    private float clampAngle = 80f;
    private float angleClamp = 58f;
    private InputManagerScript inputManagerScript;
    private Vector3 startingRotation;




    protected override void Awake()
    {
        inputManagerScript = InputManagerScript.Instance;
        base.Awake();
    }
    protected override void PostPipelineStageCallback(CinemachineVirtualCameraBase vcam, CinemachineCore.Stage stage, ref CameraState state, float deltaTime)
    {
        // Подключение камеры Cinemachine, угол обзора, настройка позиции камеры.
        if(vcam.Follow)
        {
            if(stage == CinemachineCore.Stage.Aim)
            {
                if (startingRotation == null) startingRotation = transform.localRotation.eulerAngles;
                Vector2 deltaInput = inputManagerScript.GetMouseDelta();
                startingRotation.x += deltaInput.x * verticalSpeed * Time.deltaTime;
                startingRotation.y += deltaInput.y * horizontalSpeed * Time.deltaTime;
                startingRotation.x = Mathf.Clamp(startingRotation.x, -angleClamp, angleClamp);
                startingRotation.y = Mathf.Clamp(startingRotation.y, -clampAngle, clampAngle);
                state.RawOrientation = Quaternion.Euler(-startingRotation.y, startingRotation.x, 0f);
            }
        }
    }
   

}
