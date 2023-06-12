using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PositionInWorld : MonoBehaviour
{
    [SerializeField] MeshRenderer m_MeshRenderer;
    
    void Update()
    {
        Vector4 position = transform.position;
        m_MeshRenderer.material.SetVector("_VectorGlovalPosition", position);
    }
}
