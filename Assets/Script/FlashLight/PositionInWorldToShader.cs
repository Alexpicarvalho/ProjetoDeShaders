using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Scripting;
using UnityEngine.UIElements;
using TMPro;

public class PositionInWorldToShader : MonoBehaviour
{
    [SerializeField] Material m_MeshRenderer;

    Ray ray;
    float _distance;

    [Header("Lantern things")]
    public float _maxCharge = 100f;
    public float _currentCharge = 50f;
    public float _chargeOnPickUp = 10f;
    public float _chargeLossPerSecond = 10f;
    public bool _lanternOn = false;

    [Header("UI")]
    public TextMeshProUGUI _batteryText;


    private void Update()
    {
        //Battery Handeling
        if(_lanternOn) _currentCharge -= _chargeLossPerSecond * Time.deltaTime;

        _batteryText.text = ((int)_currentCharge).ToString() + " / " + _maxCharge.ToString();

        if(Input.GetButtonDown("Fire1") && !_lanternOn) _lanternOn = true;
        else if(Input.GetButtonDown("Fire1") && _lanternOn) _lanternOn = false;

        if (_currentCharge <= 0) _lanternOn = false;

        if (!_lanternOn) return;

        // Obtém a posição do ponto para o qual o objeto está apontando
        Vector3 pointedPosition = GetPointedPosition();

        m_MeshRenderer.SetVector("_VectorGlovalPosition", pointedPosition);
    }

    private Vector3 GetPointedPosition()
    {
        
        Vector3 mousePosition = Input.mousePosition;
        ray = new Ray (transform.position, transform.forward);
        RaycastHit hit;

        // Realiza o lançamento do raio e verifica se houve colisão
        if (Physics.Raycast(ray, out hit))
        {
            
            _distance=hit.distance;
            return hit.point;
        }

        else _distance = 200;

        // Caso contrário, retorna uma posição arbitrária (por exemplo, a posição do mouse no plano XY)
        return new Vector3(mousePosition.x, mousePosition.y, 0);
    }

    private void OnTriggerEnter(Collider other)
    {
        if(_currentCharge == _maxCharge || !other.CompareTag("Battery")) return;

        Destroy(other.gameObject);

        _currentCharge += _chargeOnPickUp;
        if (_currentCharge >= _maxCharge) _currentCharge = _maxCharge;
    }

    private void OnDrawGizmos()
    {
        Gizmos.color = Color.green;
        //Gizmos.DrawRay(ray.origin, ray.direction);

        Gizmos.DrawLine(ray.origin, ray.direction*_distance+ray.origin);
    }
}
