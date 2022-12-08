using System.Collections;
using System.Collections.Generic;
using UnityEngine;


[RequireComponent(typeof(CharacterController))]
[RequireComponent(typeof(Animator))]
[RequireComponent(typeof(AudioSource))]
public class CharController : MonoBehaviour
{
    [SerializeField]
    private float playerSpeed = 2.0f;
    [SerializeField]
    private float runSpeed = 5.0f;
    private float gravityValue = -9.81f;
    private CharacterController controller;
    private Vector3 playerVelocity;
    private bool groundedPlayer;
    private InputManagerScript inputManagerScript;
    private Transform cameraTransform;
    Animator animator;
    AudioSource audio;
    float x, z;
    public Transform Cam;
    




    private void Start()
    {
        controller = GetComponent<CharacterController>();
        animator = GetComponent<Animator>();
        audio = GetComponent<AudioSource>();
        inputManagerScript = InputManagerScript.Instance;
        cameraTransform = Camera.main.transform;
        
    }
   

    void Update()
    {
        groundedPlayer = controller.isGrounded;
        if (groundedPlayer && playerVelocity.y < 0)
        {
            playerVelocity.y = 0f;
        }

        Vector2 movement = inputManagerScript.GetPlayerMovement();
        Vector3 move = new Vector3(movement.x, 0f, movement.y);
        move = cameraTransform.forward * move.z + cameraTransform.right * move.x;
        move.y = 0f;
        controller.Move(move * Time.deltaTime * playerSpeed);

        //if (move != Vector3.zero)
        //{
            //gameObject.transform.forward = move;
       // }

        // Changes the height position of the player..
        if (inputManagerScript.PlayerRun() && groundedPlayer)
        {
            controller.Move(move * Time.deltaTime * runSpeed);
        }

        playerVelocity.y += gravityValue * Time.deltaTime;
        controller.Move(playerVelocity * Time.deltaTime);

        float x = Input.GetAxis("Horizontal");
        float z = Input.GetAxis("Vertical");
        if (x != 0)
        {
            transform.Rotate(0f, x * playerSpeed, 0f);
        }
        if(x != 0 || z != 0)
        {
            animator.SetBool("Walk", true);
            Vector3 dir = transform.TransformDirection(new Vector3
            (x * playerSpeed * Time.deltaTime, 0f, z * playerSpeed * Time.deltaTime));
            controller.Move(dir);

        }
        else
        {
            animator.SetBool("Walk", false);
        }
        if(Input.GetKey(KeyCode.W) && Input.GetKey(KeyCode.LeftShift))
        {
            animator.SetBool("Run", true);
            Vector3 dir = transform.TransformDirection(new Vector3(x * playerSpeed * Time.deltaTime,
                0f, runSpeed * Time.deltaTime));
            controller.Move(dir);

        }
        else
        {
            animator.SetBool("Run", false);
        }
        if (Input.GetKeyDown(KeyCode.S))
        {
            animator.SetTrigger("Rotate");

        }
        if (Input.GetKeyDown(KeyCode.A))
        {
            animator.SetTrigger("Left");

        }
        if (Input.GetKeyDown(KeyCode.D))
        {
            animator.SetTrigger("Right");

        }

    }
    void FixedUpdate()
    {
        if(x != 0 || z !=0)
        {
            transform.rotation = Quaternion.Lerp(transform.rotation, Cam.transform.rotation, 0.1f);
        }
    }



}