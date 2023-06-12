using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerMovement : MonoBehaviour
{
    [Header("Physics")]
    public float speed = 6.0f;
    [SerializeField] private float gravity = 20.0f;
    [SerializeField] public float jumpHeight = 8.0f;
    [SerializeField] private float airSpeed = 4.0f;
    [SerializeField] private float airFriction = .65f;


    public CharacterController playerController;
    private int jumpCount = 0;
    private bool groundCheck;
    private GameObject player;
    private Animator animator;
    private Vector3 moveDirection = Vector3.zero;
    private Vector3 jumpVelocity = Vector3.zero;
    float mouseX;
    float mouseY;
    Vector3 lastPosition;
    Vector3 currentPosition;


    private void Start()
    {
        playerController = GetComponent<CharacterController>();
        player = gameObject;
       // animator = GetComponent<Animator>();
    }
    // Update is called once per frame
    void Update()
    {
        Debug.Log("Is Grounde = " + playerController.isGrounded);

        //CheckGrounded();
        mouseX = Input.GetAxis("Mouse X");
        mouseY = Input.GetAxis("Mouse Y");


        moveDirection = new Vector3(Input.GetAxis("Horizontal"), 0.0f, Input.GetAxis("Vertical"));
        moveDirection = transform.TransformDirection(moveDirection);


        if (Input.GetKey(KeyCode.LeftShift))
        {
            speed = 12.0f;
        }
        else speed = 6.0f;


        if (playerController.isGrounded/* groundCheck*/)
        {
            jumpCount = 0;
            playerController.slopeLimit = 45.0f;
            moveDirection *= speed;

            if (Input.GetKeyDown(KeyCode.Space))
            {
                jumpVelocity = moveDirection * airFriction;
                jumpVelocity.y = jumpHeight;
                playerController.slopeLimit = 90.0f;
            }
            else
            {
                jumpVelocity = Vector3.zero;
            }
        }
        else
        {
            //if (Input.GetKeyDown(KeyCode.Space) && jumpCount == 0)
            //{
            //    jumpCount++;
            //    jumpVelocity = moveDirection * airFriction;
            //    jumpVelocity.y = jumpHeight;
            //    playerController.slopeLimit = 90.0f;
            //}
            moveDirection *= airSpeed;
        }

        jumpVelocity.y -= gravity * Time.deltaTime;
        lastPosition = transform.position;
        playerController.Move((moveDirection + jumpVelocity) * Time.deltaTime);
        currentPosition = transform.position;


        //if (lastPosition != currentPosition)
        //{
        //    animator.SetBool("isRunning", true);
        //    //animator.SetBool("isRunning", false);
        //}
        //else animator.SetBool("isRunning", false);

    }
}
