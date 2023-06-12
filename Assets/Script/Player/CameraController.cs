using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraController : MonoBehaviour
{
    Camera _cam;
    Transform _head;
    float yLook;
    float desiredRotationAngle;

    [Header("Properties")]
    float _maxLookUpAngle = 90.0f;
    float _maxLookDownAngle = -90.0f;
    [SerializeField] private float mouseSensitivity;


    // Start is called before the first frame update
    void Start()
    {
        _cam = GetComponent<Camera>();
        Cursor.lockState = CursorLockMode.Locked;
        _head = transform.parent;
    }

    // Update is called once per frame
    void Update()
    {
        float mouseY = Input.GetAxis("Mouse Y") * mouseSensitivity;
        mouseY = Mathf.Clamp(mouseY, _maxLookDownAngle, _maxLookUpAngle);

        // Invert the rotation if needed (comment out this line if rotation feels inverted)
        mouseY *= -1;

        // Rotate the camera head around the local X-axis
        _head.Rotate(Vector3.right, mouseY, Space.Self);

    }
}
