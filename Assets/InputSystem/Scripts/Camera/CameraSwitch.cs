using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraSwitch : MonoBehaviour
{
    private Camera camera;
    public Camera cam;

    void Start()
    {
        camera = GetComponent<Camera>();
        camera = Camera.main;
    }
    void Update()
    {
        if(Input.GetKeyDown(KeyCode.C))
        {
            camera.enabled = !camera.enabled;
            cam.enabled = !cam.enabled;
        }
    }
}
