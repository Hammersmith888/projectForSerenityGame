using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraTPS : MonoBehaviour
{
  
    public Transform playerTarget;
    public float mouseSpeed;
    float xRot, yRot;
    public float minX, maxX;



    void Start()
    {
        
    }

    void LateUpdate()
    {
        xRot -= Input.GetAxis("Mouse Y") * Time.deltaTime * mouseSpeed;
        yRot += Input.GetAxis("Mouse X") * Time.deltaTime * mouseSpeed;
        xRot = Mathf.Clamp(xRot, minX, maxX);
        transform.GetChild(0).localRotation = Quaternion.Euler(xRot, 0, 0);
        transform.localRotation = Quaternion.Euler(0, yRot, 0);
    }
    void FixedUpdate()
    {
        transform.position = Vector3.Lerp(transform.position + new Vector3(0, 0.5f, 0), playerTarget.transform.position, 0.3f); 
    }
}
