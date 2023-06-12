using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class windMill : MonoBehaviour
{
    public Renderer targetRenderer;
    //   public Renderer targetRenderer2;
    public string propertyName = "_SliderSpeed3";
    public float sliderValue = 1f;

    private Material material;
    float rotation = 0f;
    [SerializeField] private float m_MaxScrollSpeed = 4.0f;

    private void Start()
    {
        // Disable the slider by setting its value to 0

        targetRenderer.material.SetFloat(propertyName, sliderValue);

    }

    private void Update()
    {
        rotation += m_MaxScrollSpeed * sliderValue * Time.deltaTime;
        targetRenderer.material.SetFloat(propertyName, rotation);

        if (Input.GetMouseButtonDown(0))
        {
            StartCoroutine(slowWindmill());
            // targetRenderer2.enabled = false;
        }
    }

    IEnumerator slowWindmill()
    {
        while (sliderValue > 0)
        {
            sliderValue -= Time.deltaTime * 0.3f;

            yield return null;
        }

    }
}
