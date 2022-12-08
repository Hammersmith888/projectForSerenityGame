using UnityEngine;

public class TPScamera : MonoBehaviour
{
    public Transform target;
    public Vector3 globalOffset, localOffset;
    public float distance = 5f;
    public float sensitivity = 3f;
    public float smoothTime = 0.3f;


    private Vector3 velocity = Vector3.zero;

    private void LateUpdate()
    {
        Vector3 localEuler = transform.localEulerAngles;

        localEuler.y += Input.GetAxisRaw("Mouse X") * sensitivity;
        localEuler.x += Input.GetAxisRaw("Mouse Y") * sensitivity;

        Vector3 newLocalEuler = localEuler;

        newLocalEuler.x = Mathf.Clamp(newLocalEuler.x, -85, 85f);

        transform.localEulerAngles = newLocalEuler;

        distance = Mathf.Clamp(distance - Input.GetAxis("Mouse ScrollWheel"), 1f, 10f);

        transform.position = Vector3.SmoothDamp(transform.position, CheckCollision(CalculatePosition()), ref velocity, smoothTime);
    }
    private Vector3 CalculatePosition()
    {
        return CalculateRawPosition() - transform.forward * distance;
    }
    private Vector3 CalculateRawPosition()
    {
        return target.position + globalOffset + target.TransformVector(localOffset);
    }
    private Vector3 CheckCollision(Vector3 restPos)
    {
        Camera cam = GetComponent<Camera>();

        Vector3 forwardL = transform.forward * cam.nearClipPlane;

        float cameraHeight = Mathf.Tan(cam.fieldOfView * Mathf.Deg2Rad * 0.5f);
        Vector3 upL = transform.up * Mathf.Tan(cameraHeight) * cam.nearClipPlane;

        float hFOV = Mathf.Atan(cameraHeight * cam.aspect);
        Vector3 reghtL = transform.right * Mathf.Tan(hFOV) * cam.nearClipPlane;

        float sphereRadius = (forwardL + upL + reghtL).magnitude * 0.5f;


        Vector3 rawPos = CalculateRawPosition();
        Vector3 direction = restPos - rawPos;
        RaycastHit hitInfo;

        if(Physics.SphereCast(rawPos, sphereRadius, direction, out hitInfo, distance))
        {
            restPos = rawPos + direction.normalized * hitInfo.distance;
        }

        return restPos;


    }
}
